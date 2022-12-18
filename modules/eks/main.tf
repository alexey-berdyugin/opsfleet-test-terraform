/**
  * ## Overview
  * This module utilize public "terraform-aws-modules/eks/aws" module for EKS cluster with all resources provision. Also it deploy additional resources.
  */

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

################################################################################
# Kubernetes provider configuration and auxiliary resources
################################################################################

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

resource "null_resource" "wait_for_cluster" {
  depends_on = [
    data.aws_eks_cluster.cluster
  ]

  provisioner "local-exec" {
    command     = var.wait_for_cluster_cmd
    interpreter = var.wait_for_cluster_interpreter
    environment = {
      ENDPOINT = data.aws_eks_cluster.cluster.endpoint
    }
  }
}

locals {
  autoscaler_enabled_tags = {
    "k8s.io/cluster-autoscaler/${data.aws_eks_cluster.cluster.name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled" = "true"
  }
  pre_userdata        = "yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm"
}

################################################################################
# EKS Module
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.1.0"

  cluster_name                  = var.cluster_name
  cluster_version               = var.cluster_version
  cluster_enabled_log_types     = var.cluster_enabled_log_types
  iam_role_name                 = var.cluster_iam_role_name

  vpc_id  = var.vpc_id
  subnet_ids = var.private_subnets

  cluster_endpoint_public_access        = var.cluster_endpoint_public_access
  cluster_endpoint_private_access       = var.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs  = var.cluster_endpoint_public_access_cidrs

  enable_irsa = var.enable_irsa

  aws_auth_roles = var.allowed_roles
  aws_auth_users = var.map_users

  create_kms_key            = var.enable_cluster_encryption_config

  eks_managed_node_groups = {
    general = {
      name                    = var.node_group_name
      instance_types          = var.node_groups_instance_types
      desired_size            = var.node_groups_desired_capacity
      max_size                = var.node_groups_max_capacity
      min_size                = var.node_groups_min_capacity
      create_launch_template  = true
      pre_bootstrap_user_data = local.pre_userdata
      key_name                = var.node_group_key_name == "" ? "" : var.node_group_key_name
      tags                    = var.enable_cluster_autoscaler == true ? local.autoscaler_enabled_tags : {}
      labels                  = var.node_group_k8s_labels
    }
  }
}

################################################################################
# EKS Addons
################################################################################

resource "aws_eks_addon" "vpc-cni" {
  count = var.vpc-cni_addon_enabled == true ? 1 : 0
  addon_name   = "vpc-cni"
  cluster_name = module.eks.cluster_name

  depends_on  = [data.aws_eks_cluster.cluster, null_resource.wait_for_cluster]
}

resource "aws_eks_addon" "coredns" {
  count = var.coredns_addon_enabled == true ? 1 : 0
  addon_name   = "coredns"
  cluster_name = module.eks.cluster_name

  depends_on  = [data.aws_eks_cluster.cluster, null_resource.wait_for_cluster]
}

resource "aws_eks_addon" "kube-proxy" {
  count = var.kube-proxy_addon_enabled == true ? 1 : 0
  addon_name   = "kube-proxy"
  cluster_name = module.eks.cluster_name

  depends_on  = [data.aws_eks_cluster.cluster, null_resource.wait_for_cluster]
}

resource "aws_eks_addon" "ebs-csi" {
  count = var.ebs-csi_addon_enabled == true ? 1 : 0
  addon_name   = "aws-ebs-csi-driver"
  cluster_name = module.eks.cluster_name

  depends_on  = [data.aws_eks_cluster.cluster, null_resource.wait_for_cluster]
}

################################################################################
# Setup subnet tags for the eks cluster
# These tags are specifically ignored in our terraform aws provider config
# That way the vpc module won't try to overwrite them
################################################################################

resource "aws_ec2_tag" "public_subnets" {
  for_each = toset(var.public_subnets)

  resource_id = each.key
  key         = "kubernetes.io/cluster/${data.aws_eks_cluster.cluster.id}"
  value       = "shared"
}

resource "aws_ec2_tag" "private_subnets" {
  for_each = toset(var.private_subnets)

  resource_id = each.key
  key         = "kubernetes.io/cluster/${data.aws_eks_cluster.cluster.id}"
  value       = "shared"
}
