
################################################################################
# AWS Application Load Balancer controller
# Module created according to https://github.com/kubernetes-sigs/aws-load-balancer-controller/tree/main/helm/aws-load-balancer-controller
################################################################################

# IAM Policy and Role for Application Load Balancer controller
resource "aws_iam_role_policy" "app_load_balancer" {
  count  = var.enable_app_load_balancer ? 1 : 0
  name   = "${var.cluster_name}-load-balancer-controller"
  role   = aws_iam_role.app_load_balancer[0].name
  policy = file("${path.module}/templates/iam-policy.json")           //join("", data.aws_iam_policy_document.cluster_autoscaler.*.json)
}

resource "aws_iam_role" "app_load_balancer" {
  count = var.enable_app_load_balancer ? 1 : 0
  name  = format("%s-load-balancer-controller", var.environment)
  assume_role_policy = templatefile("${path.module}/templates/oidc_assume_role_policy.json.tpl",
  {
    oidc_arn  = module.eks.oidc_provider_arn
    oidc_url  = replace(module.eks.cluster_oidc_issuer_url, "https://", ""),
    namespace = "kube-system",
    sa_name   = "aws-load-balancer-controller"
  })
  tags = merge(
  var.tags,
  {
    "ServiceAccountName"      = "aws-load-balancer-controller"
    "ServiceAccountNameSpace" = "kube-system"
  }
  )
}

# Kubernetes Service Account for ALB controller
resource "kubernetes_service_account" "aws-load-balancer-controller" {
  count = var.enable_app_load_balancer ? 1 : 0
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.app_load_balancer[0].name}"
    }
  }
}

data "kubectl_path_documents" "crds" {
  pattern = "${path.module}/templates/crds.yaml"
}

resource "kubectl_manifest" "target_group_binding" {
  count      = var.enable_app_load_balancer ? length(data.kubectl_path_documents.crds.documents) : 0
  depends_on = [ data.aws_eks_cluster.cluster, null_resource.wait_for_cluster ]
  yaml_body = element(data.kubectl_path_documents.crds.documents, count.index)
}

################################################################################
# Setup subnet tags for ALB ingress controller
# These tags allows alb ingress controller subnets auto-discovery
################################################################################

resource "aws_ec2_tag" "alb_public_subnets" {
  for_each = { for k, v in toset(var.public_subnets) : k => v if var.enable_app_load_balancer }
  resource_id = each.key
  key         = "kubernetes.io/role/elb"
  value       = 1
}

resource "aws_ec2_tag" "alb_private_subnets" {
  for_each = { for k, v in toset(var.private_subnets) : k => v if var.enable_app_load_balancer }
  resource_id = each.key
  key         = "kubernetes.io/role/internal-elb"
  value       = 1
}

resource "helm_release" "aws-load-balancer-controller" {
  depends_on  = [data.aws_eks_cluster.cluster, null_resource.wait_for_cluster, kubectl_manifest.target_group_binding ]
  count       = var.enable_app_load_balancer ? 1 : 0
  name        = "aws-load-balancer-controller"
  namespace   = "kube-system"
  chart       = "aws-load-balancer-controller"
  repository  = "https://aws.github.io/eks-charts"
  version     = var.app_load_balancer_chart_version
  wait        = length(module.eks.eks_managed_node_groups) > 0 ? true : false

  set {
    name  = "serviceAccount.create"
    value = false
  }
  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.aws-load-balancer-controller[0].metadata.0.name
  }
  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.cluster.name
  }
  set {
    name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.app_load_balancer[0].arn
  }
}