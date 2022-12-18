output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.*.cluster_name
}
output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks.*.cluster_arn
}
output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.*.cluster_endpoint
}
output "cluster_iam_role_name" {
  description = "EKS cluster IAM role name"
  value       = module.eks.*.cluster_iam_role_name
}
output "cluster_iam_role_arn" {
  description = "EKS cluster IAM role ARN"
  value       = module.eks.*.cluster_iam_role_arn
}
output "cluster_primary_security_group_id" {
  description = "EKS cluster primary SG ID"
  value       = module.eks.*.cluster_primary_security_group_id
}
output "cluster_security_group_id" {
  description = "EKS cluster SG ID"
  value       = module.eks.*.cluster_security_group_id
}
output "oidc_provider_arn" {
  description = "EKS cluster OIDC provider ARN"
  value       = module.eks.*.oidc_provider_arn
}
output "worker_security_group_id" {
  description = "EKS workers SG ID"
  value       = module.eks.*.node_security_group_id
}