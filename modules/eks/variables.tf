variable region {
  type = string
  default = "us-east-1"
  description = "Region."
}

variable "allowed_roles" {
  type = list(object({ rolearn = string, username = string, groups = list(string) }))
  default = []
  description = "Additional IAM roles to add to the aws-auth configmap."
}

variable "environment" {
  type = string
  default = "development"
  description = "Environment name."
}

variable "cluster_name" {
  type = string
  default = "dev-eks"
  description = "EKS cluster name."
}

variable "node_group_name" {
  type = string
  default = "dev-eks-node-group"
  description = "EKS Node Group name."
}

variable "cluster_iam_role_name" {
  type = string
  default = "dev-eks-iam-role"
  description = "EKS cluster IAM role name."
}

variable "company" {
  type    = string
  default = "aberdyugin"
  description = "Company name, used in naming convention."
}

variable "tags_map" {
  type    = map(string)
  default = {}
  description = "A map of tags to add to all resources. Tags added to launch configuration or templates override these values for ASG Tags only."
}

variable "created-by" {
  type    = string
  default = "terraform"
  description = "Created-by tag added to all resources."
}

variable "node_groups_desired_capacity" {
  type = number
  default = 1
  description = "Node group initial desired capacity. Later can be updated by cluster autoscaler."
}

variable "node_groups_min_capacity" {
  type = number
  default = 1
  description = "Node group Min capacity."
}

variable "node_groups_max_capacity" {
  type = number
  default = 10
  description = "Node group Max capacity."
}

variable "node_groups_instance_types" {
  type = list(string)
  default = ["m5.large"]
  description = "Node group EC2 instances type."
}

variable "node_group_key_name" {
  type = string
  default = ""
  description = "Key name for workers. Set to empty string to disable remote access."
}

variable "node_group_k8s_labels" {
  description = "Labels for kubernetes workers."
  type = map(string)
  default = {}
}

variable "cluster_enabled_log_types" {
  type = list(string)
  default = ["audit", "authenticator"]
  description = " A list of the desired control plane logging to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
}

variable "cluster_version" {
  type = string
  default = "1.21"
  description = "EKS cluster version. See [Amazon EKS Kubernetes versions](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html) for available versions"
}

variable "vpc_id" {
  type = string
  description = "VPC id to be used for EKS cluster deployment"
}

variable "public_subnets" {
  type = list(string)
  description = "List of public subnets."
}

variable "private_subnets" {
  type = list(string)
  description = "List of private subnets."
}

variable "enable_irsa" {
  type = bool
  default = true
  description = "Whether to create OpenID Connect Provider for EKS to enable IRSA."
  validation {
    condition     = can(regex("^(true|false)$", var.enable_irsa))
    error_message = "Must be true or false."
  }
}

variable "cluster_endpoint_public_access" {
  type = bool
  default = false
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. When it's set to `false` ensure to have a proper private access with `cluster_endpoint_private_access = true`."
  validation {
    condition     = can(regex("^(true|false)$", var.cluster_endpoint_public_access))
    error_message = "Must be true or false."
  }
}

variable "enable_cluster_encryption_config" {
  type = bool
  default = true
  description = "Enable EKS cluster encryption."
  validation {
    condition     = can(regex("^(true|false)$", var.enable_cluster_encryption_config))
    error_message = "Must be true or false."
  }
}

variable "cluster_endpoint_private_access" {
  type = bool
  default = true
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  validation {
    condition     = can(regex("^(true|false)$", var.cluster_endpoint_private_access))
    error_message = "Must be true or false."
  }
}

variable "cluster_endpoint_public_access_cidrs" {
  type = list(string)
  default = []
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
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

variable "enable_cluster_autoscaler" {
  type = bool
  default = true
  description = "Enable cluster autoscaler deployment."
  validation {
    condition     = can(regex("^(true|false)$", var.enable_cluster_autoscaler))
    error_message = "Must be true or false."
  }
}

variable "cluster_autoscaler_chart_version" {
  type = string
  default = "9.11.0"
  description = "Cluster Autoscaler chart version."
}

variable "wait_for_cluster_cmd" {
  description = "Custom local-exec command to execute for determining if the eks cluster is healthy. Cluster endpoint will be available as an environment variable called ENDPOINT"
  type        = string
  default     = "for i in `seq 1 60`; do wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null && exit 0 || true; sleep 10; done; echo TIMEOUT && exit 1"
}

variable "wait_for_cluster_interpreter" {
  description = "Custom local-exec command line interpreter for the command to determining if the eks cluster is healthy."
  type        = list(string)
  default     = ["/bin/sh", "-c"]
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "vpc-cni_addon_enabled" {
  description = "Enable vpc-cni EKS addon."
  type = bool
  default = false
  validation {
    condition     = can(regex("^(true|false)$", var.vpc-cni_addon_enabled))
    error_message = "Must be true or false."
  }
}

variable "coredns_addon_enabled" {
  description = "Enable coredns EKS addon."
  type = bool
  default = false
  validation {
    condition     = can(regex("^(true|false)$", var.coredns_addon_enabled))
    error_message = "Must be true or false."
  }
}

variable "kube-proxy_addon_enabled" {
  description = "Enable kube-proxy EKS addon."
  type = bool
  default = false
  validation {
    condition     = can(regex("^(true|false)$", var.kube-proxy_addon_enabled))
    error_message = "Must be true or false."
  }
}

variable "ebs-csi_addon_enabled" {
  description = "Enable ebs-csi EKS addon."
  type = bool
  default = false
  validation {
    condition     = can(regex("^(true|false)$", var.ebs-csi_addon_enabled))
    error_message = "Must be true or false."
  }
}

variable "enable_app_load_balancer" {
  description = "Enable Application Load Balancer ingress controller."
  type = bool
  default = true
  validation {
    condition     = can(regex("^(true|false)$", var.enable_app_load_balancer))
    error_message = "Must be true or false."
  }
}

variable "app_load_balancer_chart_version" {
  description = "Application Load Balancer Helm chart version."
  type = string
  default = "1.3.3"
}

variable "enable_istio" {
  type = bool
  default = false
  description = "Enable Istio installation."
  validation {
    condition     = can(regex("^(true|false)$", var.enable_istio))
    error_message = "Must be true or false."
  }
}

variable "istio_enableAutoMtls" {
  description = "Istio: enable automtls in global mesh config"
  type        = string
  default     = "true"
}

variable "istio_gateway_name" {
  description = "Istio: deploy ingressgateway with Name:"
  type        = string
  default     = ""
}

variable "create_mtls_namespace" {
  description = "Create mtls enforced k8s namespace"
  type = bool
  default = true
}