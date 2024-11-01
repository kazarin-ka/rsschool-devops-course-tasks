#!/bin/bash
set -o errexit   # abort on nonzero exit status
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

# https://www.digitalocean.com/community/tutorials/how-to-setup-k3s-kubernetes-cluster-on-ubuntu
sudo apt-get update

# installing k3s
sudo ufw disable
curl -sfL https://get.k3s.io | sh -

# make kubeconfig avaliable without sudo
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

# check statuse
sudo systemctl status k3s
kubectl get all -n kube-system

# check nodes
kubectl get nodes

# deploy simple app
kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml

# Install autocompletion in kubectl
#    https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#enable-shell-autocompletion
#sudo apt install -y bash-completion
# echo 'source <(kubectl completion bash)' >>~/.bashrc
# source ~/.bashrc
#kubectl get pods


