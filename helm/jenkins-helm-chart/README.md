# Jenkins Helm Chart

This Helm chart is designed to deploy Jenkins on a Kubernetes cluster. It includes all the necessary configurations, including service accounts, permissions, persistent storage, and service exposure to make Jenkins accessible outside the cluster.

## Prerequisites

- Kubernetes cluster (minimum version 1.16)

- Helm 3.x

- Persistent Volume provisioner support in the underlying infrastructure

## Chart Structure

```bash
├── Chart.yaml  
├── README.md  
├── templates  
│   ├── deployment.yaml  
│   ├── namespace.yaml  
│   ├── pv.yaml  
│   ├── pvc.yaml  
│   ├── role.yaml  
│   ├── rolebinding.yaml  
│   ├── service.yaml  
│   ├── serviceaccount.yaml  
│   └── storageclass.yaml  
└── values.yaml  
```

## File Descriptions

- **Chart.yaml**: Metadata about the Helm chart, such as name, version, and description
- **README.md**: Instructions and information about the Helm chart, including installation steps and structure
- **templates/**: Directory containing Kubernetes resource templates
  - **deployment.yaml**: Defines the Jenkins deployment, including replicas, containers, volumes, and probes
  - **namespace.yaml**: Creates a dedicated namespace for Jenkins
  - **pv.yaml**: Defines the PersistentVolume (PV) for Jenkins data storage
  - **pvc.yaml**: Defines the PersistentVolumeClaim (PVC) for Jenkins, which requests storage from the PV
  - **role.yaml**: Creates a ClusterRole with necessary permissions for Jenkins
  - **rolebinding.yaml**: Binds the service account to the ClusterRole for Jenkins permissions
  - **service.yaml**: Defines the Jenkins service to expose it within or outside the cluster
  - **serviceaccount.yaml**: Creates a ServiceAccount specifically for Jenkins
  - **storageclass.yaml**: Defines a StorageClass, if custom storage provisioning is required
- **values.yaml**: Default configuration values for the chart, including image version, resource limits, storage settings, and service type

## Installation

To install the Jenkins Helm chart in the namespace `jenkins` with default values, use:
```bash
helm install jenkins ./jenkins-helm-chart --namespace jenkins --create-namespace
```
To override default values, specify a custom values.yaml file:
```bash
helm install jenkins ./jenkins-helm-chart --namespace jenkins -f custom-values.yaml
```

### Jenkins config
After deployment Jenkins, visit it web interface (http://<host ip>:30000 by default)
You woll need to get initial password from node. You can get it via:
```bash
DEPLOYMENT_NAME="jenkins" # replace of needed
NAMESPACE="jenkins" # replace of needed
jenk_pod_name=$(kubectl get pods --namespace=${NAMESPACE} -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
initial_admin_password=$(kubectl exec -n ${NAMESPACE} -i "${jenk_pod_name}" -- cat /var/jenkins_home/secrets/initialAdminPassword)
echo "Jenkins init password: ${initial_admin_password}"
```

Output will be:
```
...
Jenkins init password: df2d8a452e334e5684bba1ae1b4384c8
```

Use it to create first real admin User.

### Create first job via API
You also can create your security token for api access (Profile -> security).

After that, create file `job-config.xml`:
```xml
<?xml version='1.1' encoding='UTF-8'?>
<project>
  <actions/>
  <description>Test job to print "Hello world"</description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <scm class="hudson.scm.NullSCM"/>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.tasks.Shell>
      <command>echo "Hello world"</command>
    </hudson.tasks.Shell>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>
```
And run:
```bash
## Creating job via api
jenkins_url="http://<host ip>:30000"
username="<your login>"
api_token="<your  API token>"
# create job
curl -X POST "${jenkins_url}/createItem?name=HelloWorldJob" \
    -u "${username}:${api_token}" \
    -H "Content-Type: application/xml" \
    --data-binary @job-config.xml

# run job
curl -X POST "${jenkins_url}/job/HelloWorldJob/build" \
    -u "${username}:${api_token}"
```

## Upgrading the Chart

To upgrade the Jenkins Helm chart with new values or chart updates, use:
```bash
helm upgrade jenkins ./jenkins-helm-chart --namespace jenkins -f custom-values.yaml
```
## Uninstalling the Chart

To uninstall the Jenkins Helm chart and remove all associated resources, use:
```bash
helm uninstall jenkins --namespace jenkins
```

## Monitoring and Logs

To check the status of the Jenkins deployment, use:
```bash
kubectl get deployment jenkins -n jenkins
```
To view the status of pods associated with Jenkins, use:
```bash
kubectl get pods -n jenkins
```
To view logs of the Jenkins pod, first identify the pod name, then use:
```bash
kubectl logs <jenkins-pod-name> -n jenkins
```
To follow the logs in real-time, use:
```bash
kubectl logs -f <jenkins-pod-name> -n jenkins
```