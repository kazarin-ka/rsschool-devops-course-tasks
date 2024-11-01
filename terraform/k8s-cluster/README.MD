# K3s Kubernetes Infrastructure Provisioning with Terraform

This repository contains Terraform code to provision a Kubernetes infrastructure using K3s on EC2 instances. It automates the setup of both master and worker nodes, including monitoring integration with Grafana Cloud.

## Repository Structure

- `README.md`: Documentation for this setup.
- `cloud_init_k3s.yaml`: Cloud-init script that configures the K3s nodes and integrates them with Grafana Cloud for monitoring.
- `ec2_k3s_master_nodes.tf`: Terraform configuration for creating EC2 instances for the K3s master nodes.
- `ec2_k3s_worker_nodes.tf`: Terraform configuration for creating EC2 instances for the K3s worker nodes.
- `locals.tf`: Local variables used throughout the Terraform code.
- `providers.tf`: Provider configurations for Terraform, defining which cloud provider to use.
- `sg.tf`: Security group definitions for allowing access to the EC2 instances and K3s API.
- `terraform-state.tf`: Configuration for storing Terraform's state, either locally or remotely.
- `terraform_remote_states.tf`: Remote state configuration for storing and retrieving states.
- `var.tfvars`: File containing values for the Terraform variables.
- `variables.tf`: Variable definitions for the Terraform setup.

## Purpose

This project automates the provisioning of a Kubernetes infrastructure using K3s, a lightweight Kubernetes distribution. The infrastructure includes EC2 instances acting as master and worker nodes, preconfigured to join the cluster. Additionally, each node is set up to be monitored via Grafana Cloud using cloud-init.

## What is K3s?

K3s is a lightweight Kubernetes distribution developed by Rancher. It's optimized for resource-constrained environments such as edge computing or development setups, but it can also be used for production workloads. It provides a fully compliant Kubernetes cluster with a smaller footprint.

## Dependency on `network-core` Repository

This repository depends on a neighboring repository called `network-core`, which provisions the network infrastructure where the K3s cluster will be deployed. You must first set up the resources in the `network-core` repository before applying the configurations in this repository.

Make sure that the `network-core` repository is located at the same directory level as this one, and follow its instructions to deploy the necessary network infrastructure.

## How to Run This Setup

1. Clone this repository and the `network-core` repository to your local machine, ensuring they are at the same directory level:
```bash
git clone <repository-url>
```
2. Navigate to the `network-core` repository and deploy the network infrastructure:

```bash
cd ../network-core
terraform init
terraform apply
```
3. Once the network is set up, navigate to the `k3s` repository containing the Terraform files:
```bash
cd ../<repository-directory>
```
4. Set up your Terraform backend and state configuration if necessary. Modify the `terraform_remote_states.tf` file if you want to use remote state storage.

5. Review and update the `var.tfvars` file with your specific configurations such as instance sizes, region, and Grafana Cloud credentials.

6. Initialize Terraform:
```bash
terraform init
```
7. Review the execution plan:
```bash
terraform plan
```
8. Apply the Terraform configuration to provision the infrastructure:
```bash
terraform apply
```
9. After provisioning is complete, your EC2 instances will be set up as master and worker nodes running K3s, with monitoring integrated with Grafana Cloud.

## Cleanup
To destroy the provisioned infrastructure and clean up resources, run:
```bash
terraform destroy
```

## How to connect to remote k3s cluster

### Login via ssh through Bastion host
Define your bastion host IP ( public host) and k8s host (private ip)

For example:
```bash
SSH_PUBLIC_HOST_ADDR="1.1.1.1"
SSH_PRIVATE_HOST_ADDR="192.168.10.10"
```

Create background ssh connection to bastion host with port forwarding:
```bash
ssh -f -N -L 2222:${SSH_PRIVATE_HOST_ADDR}:22 -p <bastion ssh port> <login>@${SSH_PUBLIC_HOST_ADDR} -i <ssh key path>
```

connect via ssh to your k3s host:
```bash
ssh -p 2222 <login>@127.0.0.1 -i <ssh key path>
```

### Forward kube api port via ssh

Define your bastion host IP ( public host) and k8s host (private ip)

For example:
```bash
SSH_PUBLIC_HOST_ADDR="1.1.1.1"
SSH_PRIVATE_HOST_ADDR="192.168.10.10"
```

Create background ssh connection to bastion host with port forwarding:
```bash
ssh -f -N -L 2222:${SSH_PRIVATE_HOST_ADDR}:22 -L 6443:${SSH_PRIVATE_HOST_ADDR}:6443 -p <bastion ssh port> <login>@${SSH_PUBLIC_HOST_ADDR} -i <ssh key path>
```
Connect to k3s host via ssh and copy k3s config to your local machine.
Default path is: `/etc/rancher/k3s/k3s.yaml`

On your local machine, test that Kupe api port (6443) became avaliable:
```bash
curl -k https://localhost:6443
# Answer must be:
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {},
  "status": "Failure",
  "message": "Unauthorized",
  "reason": "Unauthorized",
  "code": 401
}
```
Set env variable with path to k3s config file on your local machine:
```bash
export KUBECONFIG=/<path to file>/k3s.yaml
```

And now try to use `kubectl` in the same terminal window:
```bash
kubectl get nodes
kubectl get pods -A
```

### Finish your connection
Apply following commands when you finished
```bash
killall ssh
ssh-keygen -R [127.0.0.1]:2222
```

