
### Istio deployment and base configuration

resource "helm_release" "istio_base" {
  count = var.enable_istio == true ? 1 : 0

  name              = "istio-base"
  repository        = "https://istio-release.storage.googleapis.com/charts"
  chart             = "base"

  namespace         = "istio-system"
  create_namespace  = true
  timeout           = 120
  cleanup_on_fail   = true
  force_update      = false

  depends_on  = [data.aws_eks_cluster.cluster, null_resource.wait_for_cluster]
  wait        = length(module.eks.eks_managed_node_groups) > 0 ? true : false
}

resource "helm_release" "istiod" {
  count = var.enable_istio == true ? 1 : 0

  name              = "istiod"
  repository        = "https://istio-release.storage.googleapis.com/charts"
  chart             = "istiod"

  namespace         = "istio-system"
  create_namespace  = true
  timeout           = 120
  cleanup_on_fail   = true
  force_update      = false


  set {
    name = "meshConfig.accessLogFile"
    value = "/dev/stdout"
  }
  set {
    name = "meshConfig.enableAutoMtls"
    value = var.istio_enableAutoMtls
  }

  depends_on  = [data.aws_eks_cluster.cluster, null_resource.wait_for_cluster]
  wait        = length(module.eks.eks_managed_node_groups) > 0 ? true : false
}

resource "helm_release" "istio_ingress" {
  count = var.enable_istio == true ? 1 : 0

  name              = "istio-ingress"
  repository        = "https://istio-release.storage.googleapis.com/charts"
  chart             = "gateway"

  namespace         = "istio-system"
  create_namespace  = true
  timeout           = 500
  cleanup_on_fail   = true
  force_update      = false

  depends_on  = [data.aws_eks_cluster.cluster, null_resource.wait_for_cluster, helm_release.istiod]
  wait        = length(module.eks.eks_managed_node_groups) > 0 ? true : false
}


### Namespace with enforced mTLS creation
resource "kubernetes_namespace" "mtls-enforced" {
  count = var.enable_istio == true && var.create_mtls_namespace == true ? 1 : 0
  depends_on  = [helm_release.istiod]
  metadata {
    name = "mtls-enforced"

    labels = {
      istio-injection = "enabled"
    }
  }
}

data "kubectl_path_documents" "mtls-enforce" {
  pattern = "${path.module}/templates/mtls-enforce.yaml"
}

resource "kubectl_manifest" "enforce_mtls_on_namespace" {
  count       = var.enable_istio == true && var.create_mtls_namespace == true ? 1 : 0
  depends_on  = [helm_release.istiod, kubernetes_namespace.mtls-enforced]
  override_namespace  = kubernetes_namespace.mtls-enforced[0].metadata.0.name
  yaml_body           = element(data.kubectl_path_documents.mtls-enforce.documents, count.index)
}

resource "kubectl_manifest" "istio_gateway" {
  count       = var.enable_istio == true && var.create_mtls_namespace == true && var.istio_gateway_name != "" ? 1 : 0
  depends_on  = [helm_release.istiod, kubernetes_namespace.mtls-enforced]
  override_namespace  = kubernetes_namespace.mtls-enforced[0].metadata.0.name
  yaml_body           = templatefile("${path.module}/templates/istio-gateway.yaml.tpl",
    {
      gateway_name  = var.istio_gateway_name
    })
}