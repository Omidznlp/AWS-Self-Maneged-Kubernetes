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

### Jenkins and Terraform and AWS

![Screen Shot 2021-07-01 at 4 43 17 PM](https://user-images.githubusercontent.com/87664653/173849388-eeff12a6-806a-4a1e-8c40-a25af72267c8.png)

### Install Terraform plugin

To Install Terraform plugin,

Go to Manage Jenkins > Manage Plugins >Available > search Terraform > Choose to install Terraform plugin.

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
Go to new item > Enter an item name > choose Pipline > Click OK.
Then, To add Jenkinsfile:
Go to Advanced Project Options > In Pipline Section > Select "Pipline script from SCM" . > Select "Git" in SCM section > Insert Repository URL (<https://github.com/Omidznlp/AWS-Self-Maneged-Kubernetes.git>) in Repositoriis Section

![pipe1](https://user-images.githubusercontent.com/87664653/174334049-7c2954f9-c036-4ed3-ba87-cb5d19bcdd4e.png)

In Section Branches to build, Insert (*/master) > In Script Path, Insert (terraform/Jenkinsfile) > Click Save.

![pip2](https://user-images.githubusercontent.com/87664653/174334133-701b2cd9-9ab6-4d24-a2b5-408a8943888b.png)

## Jenkins Nodes Label

I used agent with "master" label to build Terraform Pipile, In Jenkinsfile into repositoy you can find it.

```
    agent {
      node {
        label "master"
      } 
`    }
```

I gave my Jenkins server the label "master," and then I ran Terraform on it.
Go to Manage Jenkins > Click "Manage nodes and clouds" > Select setting (left side of the list of nodes) > Under the label section, add "master" > Save it.

![nodelabel](https://user-images.githubusercontent.com/87664653/176857627-0857c869-59e9-40ce-98e3-0992a9e871cc.png)

Note! Simply, you can change the label on the Jenkinsfile or choose your node from your node lists from which you would like to execute terraform and then add the "master" label to it.

### Run Jenkins Pipline

Build with parameters: choose an action "apply or destroy"? 

![param-1](https://user-images.githubusercontent.com/87664653/183070462-4a1bf476-009c-4419-a73a-dd801f5f0a7d.png)

Before "TF Apply" or TF Destroy" stage, you must approve it manually in the Approval and Removal Stage by clicking on it and selecting "Proceed.".
![param-2](https://user-images.githubusercontent.com/87664653/183070966-98c809db-2737-448b-98e3-1539654530ac.png)

## Ansible
