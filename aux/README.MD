# K3s Single-Node Cluster Setup

This repository contains a simple setup for deploying a single-node K3s cluster using Vagrant and shell provisioning.

## Repository Structure

- README.md: Documentation for this setup.
- Vagrantfile: Configuration file for Vagrant, which defines the virtual machine and provisions it with K3s.
- lib/init.sh: Shell script used by Vagrant to install and set up K3s on the virtual machine.

## Purpose

This project provides a minimal environment to run a lightweight Kubernetes cluster using K3s. It's useful for local testing, development, or learning purposes. The single-node setup gives you a quick and easy way to experiment with Kubernetes workloads.

## What is K3s?

K3s is a lightweight Kubernetes distribution, developed by Rancher. It is optimized for resource-constrained environments such as edge, IoT, or development machines. K3s provides a fully compliant Kubernetes cluster, but with a much smaller footprint.

## How to Run This Setup

1. Clone this repository to your local machine:
```bash
git clone <repository-url>
```
2. Navigate to the directory containing the Vagrantfile:
```bash
cd <repository-directory>
```
3. Bring up the virtual machine using Vagrant:
```bash
vagrant up
```
4. Vagrant will automatically configure the VM, install K3s, and set up a single-node Kubernetes cluster.

5. Once the setup is complete, you can SSH into the VM:
```bash
vagrant ssh
```
6. K3s will be running on the VM. You can interact with it using the `kubectl` command. To check the status of the cluster, run:
```bash
kubectl get nodes
```
## Cleanup

To destroy the VM and clean up all resources, run:
```bash
vagrant destroy
```
   
