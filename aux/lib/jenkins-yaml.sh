#!/bin/bash
## this file for local experiments - if we want deploy Jenkins via simple yaml manifests for k8s (not helm!)
set -o errexit   # abort on nonzero exit status
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

CONFIG_PATH="/opt/conf/yaml"
export HOSTNAME=$(hostname)

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl create namespace devops-tools

kubectl apply -f ${CONFIG_PATH}/serviceAccount.yaml
envsubst < ${CONFIG_PATH}/persistentVolumeTemplate.yaml | kubectl apply -f -
kubectl apply -f  ${CONFIG_PATH}/deployment.yaml
kubectl apply -f ${CONFIG_PATH}/service.yaml

DEPLOYMENT_NAME="jenkins"
NAMESPACE="devops-tools"

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

## verification
  #kubectl get deployments -n devops-tools
  #kubectl describe deployments --namespace=devops-tools
  #kubectl get pods --namespace=devops-tools
jenk_pod_name=$(kubectl get pods --namespace=${NAMESPACE} -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
initial_admin_password=$(kubectl exec -n ${NAMESPACE} -i "${jenk_pod_name}" -- cat /var/jenkins_home/secrets/initialAdminPassword)
echo "Jenkins init password: ${initial_admin_password}"

## Creating job via api
#jenkins_url="http://192.168.100.100:32000"
#username="admin"
#password="admin"
## create job
#curl -X POST "${jenkins_url}/createItem?name=HelloWorldJob" \
#    -u "${username}:${api_token}" \
#    -H "Content-Type: application/xml" \
#    --data-binary @${CONFIG_PATH}/job-config.xml
#
## run job
#curl -X POST "${jenkins_url}/job/HelloWorldJob/build" \
#    -u "${username}:${api_token}"

exit 0
