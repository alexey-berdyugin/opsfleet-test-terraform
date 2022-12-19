
locals {
  cluster_name                  = "${var.environment}-eks-cluster"
  service_account_namespace     = "aberdyugin-system"
  node_group_name               = "${var.environment}-eks-node_group"
  cluster_iam_role_name         = "${var.environment}-eks-cluster-iam-role"
}

module "eks" {
  source = "../../../modules/eks"

  environment           = var.environment
  cluster_name          = local.cluster_name
  cluster_version       = var.cluster_version
  cluster_iam_role_name = local.cluster_iam_role_name
  allowed_roles         = var.map_roles
  map_users             = var.map_users

  ###  EKS addons configuration, by default all enabled
  vpc-cni_addon_enabled     = var.vpc-cni_addon_enabled
  coredns_addon_enabled     = var.coredns_addon_enabled
  kube-proxy_addon_enabled  = var.kube-proxy_addon_enabled
  ebs-csi_addon_enabled     = var.ebs-csi_addon_enabled
  enable_app_load_balancer  = var.enable_app_load_balancer
  enable_cluster_autoscaler = var.enable_cluster_autoscaler
  enable_istio              = var.enable_istio
  istio_gateway_name        = var.istio_gateway_name

  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  ###  Network configuration
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc.vpc_id
  private_subnets = data.terraform_remote_state.vpc.outputs.vpc.private_subnets_ids
  public_subnets  = data.terraform_remote_state.vpc.outputs.vpc.public_subnets_ids

  ###  Node group configuration
  node_group_name              = local.node_group_name
  node_groups_instance_types   = var.node_groups_instance_types
  node_groups_desired_capacity = var.node_groups_desired_capacity
  node_groups_min_capacity     = var.node_groups_min_capacity
  node_groups_max_capacity     = var.node_groups_max_capacity
  node_group_k8s_labels        = var.node_group_k8s_labels

}