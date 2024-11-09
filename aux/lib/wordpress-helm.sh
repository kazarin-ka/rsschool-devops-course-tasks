#!/bin/bash
## this file for local experiments - if we want deploy Jenkins via our own helm chart
set -o errexit   # abort on nonzero exit status
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

CONFIG_PATH="/opt/task_5"
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

mkdir -p ${CONFIG_PATH}
git clone https://github.com/kazarin-ka/rs-school_task-5.git ${CONFIG_PATH}
helm install my-wordpress ${CONFIG_PATH}/wordpress --set wordpress.service.nodePort=32000

#kubectl get deployment --namespace=jenkins
#kubectl get pods -n jenkins
#kubectl logs -f deployment/jenkins -n jenkins


exit 0