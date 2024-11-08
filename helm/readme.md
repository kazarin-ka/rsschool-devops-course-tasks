# Helm Charts Directory

This directory contains Helm charts for deploying various applications on a Kubernetes cluster. Currently, it includes the Helm chart for deploying Jenkins.

## Structure
```bash
helm/
└── jenkins-helm-chart 
```
## Available Charts

- **jenkins-helm-chart**: A Helm chart to deploy Jenkins, a popular open-source automation server, onto a Kubernetes cluster. This chart includes all the necessary configurations for setting up Jenkins, including persistent storage, service exposure, and role-based access control.

## Usage

To use any Helm chart from this directory, navigate to the specific chart directory and follow the instructions in the chart's README (if available), or follow these general steps:

1. **Navigate to the chart directory**:
```bash
   cd helm/jenkins-helm-chart
```
2. **Install the chart**:
```bash
helm install <release-name> ./jenkins-helm-chart --namespace <namespace> --create-namespace
```
3. **Customize Values**:

To customize the deployment, create a custom `values.yaml` file with your configurations. Then install or upgrade the chart with your custom values:
```bash
helm install <release-name> ./jenkins-helm-chart --namespace <namespace> -f custom-values.yaml
```
4. **Upgrade or Uninstall the Chart**:

- To upgrade the chart with new values or an updated version:
```bash
helm upgrade <release-name> ./jenkins-helm-chart --namespace <namespace> -f custom-values.yaml
```
- To uninstall the chart and remove all associated resources:
```bash
helm uninstall <release-name> --namespace <namespace>
```
## Requirements

Ensure that Helm is installed and properly configured on your system. You will also need access to a Kubernetes cluster where you have the necessary permissions to create namespaces, deployments, and other Kubernetes resources.

