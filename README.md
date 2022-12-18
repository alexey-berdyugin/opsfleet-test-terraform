## Overview
This code deploys AWS infrastructure for Opsfleet test task. 

The task was to install EKS with Istio in any way, but for my opinion Terraform is the best way, so I used it.

Current variables configuration for test environment deploys sufficient minimal required for test task configuration. 

Both modules utilize public VPC and EKS modules.

## Requirements
- Terraform 1.3.6
- AWS CLI

## Deployed resources
List of deployed resources for current task. Possibilities of modules are higher.
- Network Tier
  - VPC
  - Public subnets x2
  - Private subnets x2 (for EKS cluster)
  - IGW
  - Public route table
  - Private route tables
- EKS cluster
  - Managed Node group
  - Security Groups
  - IAM roles with policies
  - Additional addons
    - Istio 
    - VPC-CNI 
    - CoreDNS
    - Kube-proxy
  - Kubernetes namespace for Istio with mTLS enforcement (optional)

## Deployment Guide
1. Install requirements
2. Configure access to AWS account where infrastructure going to be deployed
3. Download this repository if not yet
4. Create S3 bucket for state and DynamoDB table for state locks
5. Update all `remote_states.tf` files
6. Deploy Network tier
   - `cd ./envs/test/Network`
   - verify variables in file `terraform.tfvars`
   - verify plan `terraform plan`
   - deploy `terraform apply`
7. Deploy EKS cluster
   - `cd ./envs/test/eks`
   - verify variables in file `terraform.tfvars`. Details about EKS configurations can be found [here](modules/eks/README.md) 
   - verify plan `terraform plan`
   - deploy `terraform apply`

