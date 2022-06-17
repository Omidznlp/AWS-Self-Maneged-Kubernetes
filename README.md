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


## Jenkins

To Install Terraform plugin,
Go to Manage Jenkins > Manage Plugins >Available > search Terraform.
To add Terraform Pipeline,
Go to new item > Enter an item name > choose Pipline > Click OK
To add Jenkinsfile > Advanced Project Options > Pipline > select Pipline script from SCM > Insert Repository URL (https://github.com/Omidznlp/AWS-Self-Maneged-Kubernetes.git) > In Section Branches to build, Insert (*/master) > In Script Path, Insert (terraform/Jenkinsfile) 
## Jenkins and Terraform and AWS


![Screen Shot 2021-07-01 at 4 43 17 PM](https://user-images.githubusercontent.com/87664653/173849388-eeff12a6-806a-4a1e-8c40-a25af72267c8.png)
