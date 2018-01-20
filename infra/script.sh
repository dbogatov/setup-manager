#!/usr/bin/env bash 

set -e

shopt -s globstar

# Ensure that the CWD is set to script's location
cd "${0%/*}"
CWD=$(pwd)

# Initiate cluster

echo "Initializing cluster on DigitalOcean"

cd $CWD/terraform/clusters/
terraform destroy -auto-approve
terraform init
terraform apply -auto-approve

# Add SWAP to master

echo "Adding SWAP file to the master"

cd $CWD

ssh -o "StrictHostKeyChecking no" core@dolores.digital-ocean.dbogatov.org "sudo mkdir -p /var/vm"
ssh -o "StrictHostKeyChecking no" core@dolores.digital-ocean.dbogatov.org "sudo fallocate -l 2048m /var/vm/swapfile1"
ssh -o "StrictHostKeyChecking no" core@dolores.digital-ocean.dbogatov.org "sudo chmod 600 /var/vm/swapfile1"
ssh -o "StrictHostKeyChecking no" core@dolores.digital-ocean.dbogatov.org "sudo mkswap /var/vm/swapfile1"

cat >var-vm-swapfile1.swap <<EOL
[Unit]
Description=Turn on swapcd clu	

[Swap]
What=/var/vm/swapfile1

[Install]
WantedBy=multi-user.target
EOL

scp var-vm-swapfile1.swap core@dolores.digital-ocean.dbogatov.org:/home/core

ssh -o "StrictHostKeyChecking no" core@dolores.digital-ocean.dbogatov.org "sudo mv var-vm-swapfile1.swap /etc/systemd/system/"
ssh -o "StrictHostKeyChecking no" core@dolores.digital-ocean.dbogatov.org "sudo systemctl enable --now var-vm-swapfile1.swap"

rm var-vm-swapfile1.swap

# Deploy addons

echo "Deploying addons"

cd $CWD/terraform

echo "Deploying dashboard"

kubectl apply -R -f addons/dashboard/
sleep 5

echo "Deploying cluo"

kubectl apply -R -f addons/cluo/
sleep 5

echo "Deploying prometheus"

kubectl apply -R -f addons/prometheus/ || true
kubectl apply -R -f addons/prometheus/
sleep 5

echo "Deploying graphana"

kubectl apply -R -f addons/grafana/
sleep 5

echo "Deploying heapster"

kubectl apply -R -f addons/heapster/
sleep 5

echo "Deploying NGINX Ingress"

kubectl apply -R -f addons/nginx-ingress/digital-ocean/ || true
kubectl apply -R -f addons/nginx-ingress/digital-ocean/
sleep 5

echo "Done!"

# cd ..
# kubectl apply -f services/namespace.yaml
# kubectl apply -R -f services/
