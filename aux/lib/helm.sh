#!/bin/bash
set -o errexit   # abort on nonzero exit status
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

##### Installing Helm

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install -y helm

## check helm with nginx installer
#export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
#helm install helm-nginx oci://registry-1.docker.io/bitnamicharts/nginx

## check
#kubectl get pods
#kubectl get services
#helm list
#
## remove
#helm uninstall helm-nginx

exit 0
