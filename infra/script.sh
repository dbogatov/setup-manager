#!/usr/bin/env bash 

set -e

shopt -s globstar

# Ensure that the CWD is set to script's location
cd "${0%/*}"
CWD=$(pwd)

# Checks

usage () {
	printf "usage: ./$0 <certDirPath> <statusSiteConfig>\n"
	printf "where\n"
	# printf "\t pswd - docker registry password for host registry.dbogatov.org and user dbogatov\n"
	printf "\t certDirPath - absolute path to directory with SSL cert (certificate.crt) and key (certificate.key) file\n"
	printf "\t statusSiteConfig - absolute path to appsettings.production.yml file\n"

	exit 1;
}

if ! [ $# -eq 2 ]
then
	usage
fi

source .secret.sh

CERTDIRPATH=$1
STATUSSITECONFIG=$2

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

echo "Adding SWAP file to the nodes"

cd $CWD

IPS=($(dig +short A dolores-workers.digital-ocean.dbogatov.org))
IPS+=($(dig +short A dolores.digital-ocean.dbogatov.org))

cat >var-vm-swapfile1.swap <<EOL
[Unit]
Description=Turn on swapcd clu	

[Swap]
What=/var/vm/swapfile1

[Install]
WantedBy=multi-user.target
EOL

for ip in ${IPS[@]}
do

	echo "Adding space for node $ip"

	ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" core@$ip "sudo mkdir -p /var/vm"
	ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" core@$ip "sudo fallocate -l 2048m /var/vm/swapfile1"
	ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" core@$ip "sudo chmod 600 /var/vm/swapfile1"
	ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" core@$ip "sudo mkswap /var/vm/swapfile1"

	scp  -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" var-vm-swapfile1.swap core@$ip:/home/core

	ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" core@$ip "sudo mv var-vm-swapfile1.swap /etc/systemd/system/"
	ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" core@$ip "sudo systemctl enable --now var-vm-swapfile1.swap"

	echo "Enabling SWAP support for kubelet"

	ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" core@$ip "sudo sed -i '/kubelet-wrapper/a \  --fail-swap-on=false \\\' /etc/systemd/system/kubelet.service"

done

rm var-vm-swapfile1.swap

# Let it warm up

echo "Waiting 30 secs..."

sleep 30

cd $CWD

echo "Creating namespaces and saving SSL certs"

NAMESPACES=("websites" "monitoring" "ingress" "status-site" "kube-system")

for namespace in ${NAMESPACES[@]}
do
	kubectl create namespace $namespace || true # some of them already exist
	kubectl create --namespace=$namespace secret tls lets-encrypt --key $CERTDIRPATH/certificate.key --cert $CERTDIRPATH/certificate.crt
	kubectl create --namespace=$namespace secret generic basic-auth --from-file=$CERTDIRPATH/auth
done

echo "Deploying the registry secret"

kubectl --namespace=websites create secret docker-registry regsecret --docker-server=registry.dbogatov.org --docker-username=dbogatov --docker-password=$DOCKERPASS --docker-email=dmytro@dbogatov.org

# Save SSL certs

kubectl create secret generic kubernetes-dashboard-certs --from-file=$CERTDIRPATH -n kube-system

# Deploy addons

echo "Deploying addons"

cd $CWD/terraform

echo "Deploying dashboard"

kubectl apply -R -f addons/dashboard/

# echo "Deploying cluo"

# kubectl apply -R -f addons/cluo/

echo "Deploying prometheus"

kubectl apply -R -f addons/prometheus/

echo "Deploying graphana"

kubectl apply -R -f addons/grafana/

echo "Deploying heapster"

kubectl apply -R -f addons/heapster/

echo "Deploying NGINX Ingress"

kubectl apply -R -f addons/nginx-ingress/digital-ocean/

echo "Deploying the websites"

cd $CWD

echo "Generating config files"

./build-services.sh

echo "Applying config files"

kubectl apply -R -f sources/nginx/

kubectl apply -R -f services/

kubectl apply -R -f dashboard/

echo "Deploying status site SKIPPED"

# kubectl create secret -n status-site generic appsettings.production.yml --from-file=$STATUSSITECONFIG

# TODO should be master
# BRANCH="49-move-to-kubernetes-deployment"

# kubectl apply -f https://git.dbogatov.org/dbogatov/status-site/-/jobs/artifacts/$BRANCH/raw/deployment/config.yaml?job=release-deployment

# kubectl apply -R -f sources/status-site/

echo "Done!"

echo "Here is the dashboard login token:"

DASHBOARD_TOKEN=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') | grep token: )
DASHBOARD_TOKEN="${DASHBOARD_TOKEN:7:${#DASHBOARD_TOKEN}}"

echo $DASHBOARD_TOKEN
