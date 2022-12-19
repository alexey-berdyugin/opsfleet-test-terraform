environment                   = "test"
cluster_version               = "1.24"
node_groups_instance_types     = ["t3.medium"]
node_groups_desired_capacity  = "1"
node_groups_min_capacity      = "1"
node_groups_max_capacity      = "2"
node_group_k8s_labels         = {
  "role" = "workers"
}
cluster_endpoint_public_access        = true
cluster_endpoint_public_access_cidrs  = ["85.113.25.101/32"]

enable_cluster_autoscaler = false
enable_app_load_balancer  = false
ebs-csi_addon_enabled     = false
coredns_addon_enabled     = true
enable_istio              = true
istio_gateway_name        = "mtld-gateway"

map_roles = [{
  rolearn   = "arn:aws:iam::841716521361:role/aws-reserved/sso.amazonaws.com/us-east-1/AWSReservedSSO_llnw-sandbox-dev-eks-admin_65f693ecd5e7b0e5"
  username  = "admin"
  groups    = ["system:masters"]
}]

map_users = [{
  userarn   = "arn:aws:iam::384840310136:user/aberdyugin"
  username  = "alex"
  groups    = ["system:masters"]
}]