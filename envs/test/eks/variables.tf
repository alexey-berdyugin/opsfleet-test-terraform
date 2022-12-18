variable "environment" {
  description = "Environment name"
}
variable "cluster_version" {
  description = "EKS cluster version"
}
variable "node_groups_instance_types" {
  description = "EKS workers instance type"
}
variable "node_groups_desired_capacity" {
  description = "EKS workers desired number"
}
variable "node_groups_min_capacity" {
  description = "EKS workers min number"
}
variable "node_groups_max_capacity" {
  description = "EKS workers max number"
}
variable "node_group_k8s_labels" {
  description = "Labels for EKS workers"
}
variable "cluster_endpoint_public_access" {
  description = "Enable public EKS cluster endpoint"
}
variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDRs to access EKS public API endpoint"
}
variable "vpc-cni_addon_enabled" {
  description = "Amazon EKS supports native VPC networking with the Amazon VPC Container Network Interface (CNI) plugin for Kubernetes. Using this plugin allows Kubernetes pods to have the same IP address inside the pod as they do on the VPC network."
  default = true
}
variable "coredns_addon_enabled" {
  description = "Enable service discovery within your cluster"
  default = true
}
variable "kube-proxy_addon_enabled" {
  description = "Enable service networking within your cluster"
  default = true
}
variable "ebs-csi_addon_enabled" {
  description = "Enable AWS EBS within your cluster"
  default = true
}
variable "enable_app_load_balancer" {}
variable "enable_cluster_autoscaler" {}
variable "enable_istio" {}

variable "map_roles" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default     = []
  description = "List of role mappings to allow access to the cluster"
}

variable "map_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default     = []
  description = "List of users mappings to allow access to the cluster"
}