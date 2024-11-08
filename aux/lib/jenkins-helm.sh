#!/bin/bash
## this file for local experiments - if we want deploy Jenkins via our own helm chart
set -o errexit   # abort on nonzero exit status
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

CONFIG_PATH="/opt/helm"
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

helm install jenkins ${CONFIG_PATH}/jenkins-helm-chart #--set jenkins.service.nodePort=32000

DEPLOYMENT_NAME="jenkins"
NAMESPACE="jenkins"

while true; do
    ready_replicas=$(kubectl get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o jsonpath='{.status.readyReplicas}')
    desired_replicas=$(kubectl get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.replicas}')

    if [[ "$ready_replicas" == "$desired_replicas" && -n "$ready_replicas" ]]; then
        echo "Deployment $DEPLOYMENT_NAME Is ready: $ready_replicas/$desired_replicas replicas."
        break
    else
        echo "Readiness: $ready_replicas/$desired_replicas replicas. Waiting..."
        sleep 5
    fi
done

jenk_pod_name=$(kubectl get pods --namespace=${NAMESPACE} -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
initial_admin_password=$(kubectl exec -n ${NAMESPACE} -i "${jenk_pod_name}" -- cat /var/jenkins_home/secrets/initialAdminPassword)
echo "Jenkins init password: ${initial_admin_password}"

#kubectl get deployment --namespace=jenkins
#kubectl get pods -n jenkins
#kubectl logs -f deployment/jenkins -n jenkins


exit 0
