#!/usr/bin/env bash 

set -e

shopt -s globstar

# Ensure that the CWD is set to script's location
cd "${0%/*}"
CWD=$(pwd)

# Checks

usage () {
	printf "usage: ./$0 <pswd> <certDirPath>\n"
	printf "where\n"
	printf "\t pswd - docker registry password for host registry.dbogatov.org and user dbogatov\n"
	printf "\t certDirPath - absolute path to directory with SSL cert (certificate.crt) and key (certificate.key) file\n"

	exit 1;
}

if ! [ $# -eq 2]
then
	usage
fi

DOCKERPASS=$1
CERTDIRPATH=$2

# Initiate cluster

echo "Initializing cluster on DigitalOcean"

# Add identity
ssh-add ~/.ssh/id_rsa

cd $CWD/terraform/clusters/
terraform destroy -force
terraform init
terraform apply -auto-approve

echo "Waiting 30 secs..."

sleep 30

# Add SWAP to master

echo "Adding SWAP file to the master"

cd $CWD

ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" core@dolores.digital-ocean.dbogatov.org "sudo mkdir -p /var/vm"
ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" core@dolores.digital-ocean.dbogatov.org "sudo fallocate -l 2048m /var/vm/swapfile1"
ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" core@dolores.digital-ocean.dbogatov.org "sudo chmod 600 /var/vm/swapfile1"
ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" core@dolores.digital-ocean.dbogatov.org "sudo mkswap /var/vm/swapfile1"

cat >var-vm-swapfile1.swap <<EOL
[Unit]
Description=Turn on swapcd clu	

[Swap]
What=/var/vm/swapfile1

[Install]
WantedBy=multi-user.target
EOL

scp  -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" var-vm-swapfile1.swap core@dolores.digital-ocean.dbogatov.org:/home/core

ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" core@dolores.digital-ocean.dbogatov.org "sudo mv var-vm-swapfile1.swap /etc/systemd/system/"
ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" core@dolores.digital-ocean.dbogatov.org "sudo systemctl enable --now var-vm-swapfile1.swap"

rm var-vm-swapfile1.swap

# Let it warm up

echo "Waiting 30 secs..."

sleep 30

cd $CWD

echo "Generating config files"

./build-services.sh

kubectl apply -f services/namespace.yaml

echo "Deploying the registry secret"

kubectl --namespace=websites create secret docker-registry regsecret --docker-server=registry.dbogatov.org --docker-username=dbogatov --docker-password=$DOCKERPASS --docker-email=dmytro@dbogatov.org

# Save SSL certs

echo "Saving SSL certs"

# for websites
kubectl create --namespace=websites secret tls lets-encrypt --key --key $CERTDIRPATH/certificate.crt --cert $CERTDIRPATH/certificate.crt --cert $CERTDIRPATH/certificate.key

# for dashboard
kubectl create --namespace=kube-system secret tls lets-encrypt --key $CERTDIRPATH/certificate.crt --cert $CERTDIRPATH/certificate.key
kubectl create secret generic kubernetes-dashboard-certs --from-file=$CERTDIRPATH -n kube-system


# Deploy addons

echo "Deploying addons"

cd $CWD/terraform

echo "Deploying dashboard"

kubectl apply -R -f addons/dashboard/

echo "Deploying cluo"

kubectl apply -R -f addons/cluo/

echo "Deploying prometheus"

kubectl apply -R -f addons/prometheus/ || true
kubectl apply -R -f addons/prometheus/

echo "Deploying graphana"

kubectl apply -R -f addons/grafana/

echo "Deploying heapster"

kubectl apply -R -f addons/heapster/

echo "Deploying NGINX Ingress"

kubectl apply -R -f addons/nginx-ingress/digital-ocean/ || true
kubectl apply -R -f addons/nginx-ingress/digital-ocean/

echo "Deploying the websites"

cd $CWD

echo "Applying config files"

kubectl apply -R -f sources/nginx/

kubectl apply -R -f services/

echo "Done!"

echo "Here is the dashboard login token:"

DASHBOARD_TOKEN=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') | grep token: )
DASHBOARD_TOKEN="${DASHBOARD_TOKEN:7:${#DASHBOARD_TOKEN}}"

echo $DASHBOARD_TOKEN
