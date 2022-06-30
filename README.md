# AWS-Self-Maneged-Kubernetes

This repository helps to build a self-managed Kubenetes cluster on AWS infrastructure using Terraform with Jenkins pipeline. Then, Ansible is used to configure Kubernetes and install Helm, Istio, and run microservices on the master node. How to use this repository is coming very soon. 

## Social Network Microservices

A social network with unidirectional follow relationships, developed using microservices with loose coupling that communicate over Thrift RPCs.
Application Structure

<img width="1249" alt="socialNet_arch" src="https://user-images.githubusercontent.com/87664653/169954472-b2fa3790-c40b-4a6d-9ce3-4e0ee197c381.png">

Ref:
https://github.com/delimitrou/DeathStarBench

## AWS Architecture

![Untitled Diagram drawio](https://user-images.githubusercontent.com/87664653/169788573-db6dd63e-c3e8-439f-ac10-236a91d7debc.png)

### Jenkins and Terraform and AWS


![Screen Shot 2021-07-01 at 4 43 17 PM](https://user-images.githubusercontent.com/87664653/173849388-eeff12a6-806a-4a1e-8c40-a25af72267c8.png)

## Jenkins

### Install Terraform plugin

To Install Terraform plugin,
Go to Manage Jenkins > Manage Plugins >Available > search Terraform.\

### Add AWS Credentiols

To configure AWS credentials in Jenkins:

1. Install Pipeline: AWS Steps
 navigate to Manage Jenkins > Manage Plugins under the Available tab of the Jenkins dashboard. Choose to install the Pipeline: AWS Steps plugin without a restart.

2. Add Aws credentials:
  You can add credentials by navigating to Manage Jenkins > Manage Credentials > Jenkins (global) > Global Credentials > Add Credentials. Choose kind as AWS credentials and enter "terraform-credentials" as the ID. Enter the access key ID and access key secret, then select OK.
![1cred](https://user-images.githubusercontent.com/87664653/176715051-1f5689b8-54b6-41a5-bc20-5540d8023519.png)
Note!
if you can not see the AWS credentials after adding the plugin.
please go to Manage Jenkins >  Configure Credential Providers > change Providers to all available and change types to all availlable.
![2 credentioalproviders](https://user-images.githubusercontent.com/87664653/176715202-9e3c1f24-1fac-4d49-a836-3f2692822b08.png)
### Add Terraform Pipeline

To add Terraform Pipeline,
Go to new item > Enter an item name > choose Pipline > Click OK

To add Jenkinsfile > Go to Pipline > Select "Pipline script from SCM" > Insert

Repository URL (<https://github.com/Omidznlp/AWS-Self-Maneged-Kubernetes.git>)

![pipe1](https://user-images.githubusercontent.com/87664653/174334049-7c2954f9-c036-4ed3-ba87-cb5d19bcdd4e.png)

In Section Branches to build, Insert (*/master) > In Script Path, Insert (terraform/Jenkinsfile) > Click Save 

![pip2](https://user-images.githubusercontent.com/87664653/174334133-701b2cd9-9ab6-4d24-a2b5-408a8943888b.png)

### Run Jenkins Pipline

![jeankens-pipline](https://user-images.githubusercontent.com/87664653/174333990-f6b5789d-13cc-4d00-817e-75516f4f0018.png)


