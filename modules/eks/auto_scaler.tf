data "aws_iam_policy_document" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0
  statement {
    sid = "AllowToScaleEKSNodeGroupAutoScalingGroup"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = [
      "*"
    ]
  }
}

### IAM Role with inbound policy for cluster autoscaler
resource "aws_iam_role_policy" "cluster_autoscaler" {
  count  = var.enable_cluster_autoscaler ? 1 : 0
  name   = "${var.cluster_name}-autoscaler"
  role   = aws_iam_role.cluster_autoscaler[0].name
  policy = join("", data.aws_iam_policy_document.cluster_autoscaler.*.json)
}

resource "aws_iam_role" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0
  name  = format("%s-cluster-autoscaler", var.environment)
  assume_role_policy = templatefile("${path.module}/templates/oidc_assume_role_policy.json.tpl",
    {
      oidc_arn  = module.eks.oidc_provider_arn
      oidc_url  = replace(module.eks.cluster_oidc_issuer_url, "https://", ""),
      namespace = "kube-system",
      sa_name   = "cluster-autoscaler"
  })
  tags = merge(
    var.tags,
    {
      "ServiceAccountName"      = "cluster-autoscaler"
      "ServiceAccountNameSpace" = "kube-system"
    }
  )
}

################################################################################
# Cluster Autoscaler Helm chart
################################################################################

resource "helm_release" "cluster-autoscaler" {
  depends_on  = [data.aws_eks_cluster.cluster, null_resource.wait_for_cluster ]
  wait        = length(module.eks.eks_managed_node_groups) > 0 ? true : false
  count       = var.enable_cluster_autoscaler ? 1 : 0
  name        = "cluster-autoscaler"
  namespace   = "kube-system"
  chart       = "cluster-autoscaler"
  repository  = "https://kubernetes.github.io/autoscaler"
  version     = var.cluster_autoscaler_chart_version

  set {
    name  = "autoDiscovery.clusterName"
    value = data.aws_eks_cluster.cluster.id
  }
  set {
    name = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cluster_autoscaler[0].arn
  }
  set {
    name  = "autoDiscovery.cloudProvider"
    value = "aws"
  }
  set {
    name  = "awsRegion"
    value = var.region
  }
  set {
    name = "extraArgs.expander"
    value = "least-waste"
  }
  set {
    name = "extraArgs.skip-nodes-with-local-storage"
    value = "false"
  }
  set {
    name = "extraArgs.balance-similar-node-groups"
    value = "true"
  }
  set {
    name = "extraArgs.skip-nodes-with-system-pods"
    value = "false"
  }
  set {
    name = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }
}