## Overview
This module utilize public "terraform-aws-modules/eks/aws" module for EKS cluster with all resources provision. Also it deploy additional resources.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.7.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.72 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.7.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.7.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 19.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_tag.alb_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_ec2_tag.alb_public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_ec2_tag.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_ec2_tag.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_eks_addon.coredns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.ebs-csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.kube-proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.vpc-cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_iam_role.app_load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.app_load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [helm_release.aws-load-balancer-controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cluster-autoscaler](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istiod](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.enforce_mtls_on_namespace](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.target_group_binding](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.mtls-enforced](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_service_account.aws-load-balancer-controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [null_resource.wait_for_cluster](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [kubectl_path_documents.crds](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/data-sources/path_documents) | data source |
| [kubectl_path_documents.mtls-enforce](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/data-sources/path_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_roles"></a> [allowed\_roles](#input\_allowed\_roles) | Additional IAM roles to add to the aws-auth configmap. | `list(object({ rolearn = string, username = string, groups = list(string) }))` | `[]` | no |
| <a name="input_app_load_balancer_chart_version"></a> [app\_load\_balancer\_chart\_version](#input\_app\_load\_balancer\_chart\_version) | Application Load Balancer Helm chart version. | `string` | `"1.3.3"` | no |
| <a name="input_cluster_autoscaler_chart_version"></a> [cluster\_autoscaler\_chart\_version](#input\_cluster\_autoscaler\_chart\_version) | Cluster Autoscaler chart version. | `string` | `"9.11.0"` | no |
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | A list of the desired control plane logging to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html) | `list(string)` | <pre>[<br>  "audit",<br>  "authenticator"<br>]</pre> | no |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled. | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled. When it's set to `false` ensure to have a proper private access with `cluster_endpoint_private_access = true`. | `bool` | `false` | no |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | List of CIDR blocks which can access the Amazon EKS public API server endpoint. | `list(string)` | `[]` | no |
| <a name="input_cluster_iam_role_name"></a> [cluster\_iam\_role\_name](#input\_cluster\_iam\_role\_name) | EKS cluster IAM role name. | `string` | `"dev-eks-iam-role"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name. | `string` | `"dev-eks"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | EKS cluster version. See [Amazon EKS Kubernetes versions](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html) for available versions | `string` | `"1.21"` | no |
| <a name="input_company"></a> [company](#input\_company) | Company name, used in naming convention. | `string` | `"aberdyugin"` | no |
| <a name="input_coredns_addon_enabled"></a> [coredns\_addon\_enabled](#input\_coredns\_addon\_enabled) | Enable coredns EKS addon. | `bool` | `false` | no |
| <a name="input_create_mtls_namespace"></a> [create\_mtls\_namespace](#input\_create\_mtls\_namespace) | Create mtls enforced k8s namespace | `bool` | `true` | no |
| <a name="input_created-by"></a> [created-by](#input\_created-by) | Created-by tag added to all resources. | `string` | `"terraform"` | no |
| <a name="input_ebs-csi_addon_enabled"></a> [ebs-csi\_addon\_enabled](#input\_ebs-csi\_addon\_enabled) | Enable ebs-csi EKS addon. | `bool` | `false` | no |
| <a name="input_enable_app_load_balancer"></a> [enable\_app\_load\_balancer](#input\_enable\_app\_load\_balancer) | Enable Application Load Balancer ingress controller. | `bool` | `true` | no |
| <a name="input_enable_cluster_autoscaler"></a> [enable\_cluster\_autoscaler](#input\_enable\_cluster\_autoscaler) | Enable cluster autoscaler deployment. | `bool` | `true` | no |
| <a name="input_enable_cluster_encryption_config"></a> [enable\_cluster\_encryption\_config](#input\_enable\_cluster\_encryption\_config) | Enable EKS cluster encryption. | `bool` | `true` | no |
| <a name="input_enable_irsa"></a> [enable\_irsa](#input\_enable\_irsa) | Whether to create OpenID Connect Provider for EKS to enable IRSA. | `bool` | `true` | no |
| <a name="input_enable_istio"></a> [enable\_istio](#input\_enable\_istio) | Enable Istio installation. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name. | `string` | `"development"` | no |
| <a name="input_istio_enableAutoMtls"></a> [istio\_enableAutoMtls](#input\_istio\_enableAutoMtls) | Istio: enable automtls in global mesh config | `string` | `"true"` | no |
| <a name="input_kube-proxy_addon_enabled"></a> [kube-proxy\_addon\_enabled](#input\_kube-proxy\_addon\_enabled) | Enable kube-proxy EKS addon. | `bool` | `false` | no |
| <a name="input_map_users"></a> [map\_users](#input\_map\_users) | List of users mappings to allow access to the cluster | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_node_group_k8s_labels"></a> [node\_group\_k8s\_labels](#input\_node\_group\_k8s\_labels) | Labels for kubernetes workers. | `map(string)` | `{}` | no |
| <a name="input_node_group_key_name"></a> [node\_group\_key\_name](#input\_node\_group\_key\_name) | Key name for workers. Set to empty string to disable remote access. | `string` | `""` | no |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | EKS Node Group name. | `string` | `"dev-eks-node-group"` | no |
| <a name="input_node_groups_desired_capacity"></a> [node\_groups\_desired\_capacity](#input\_node\_groups\_desired\_capacity) | Node group initial desired capacity. Later can be updated by cluster autoscaler. | `number` | `1` | no |
| <a name="input_node_groups_instance_types"></a> [node\_groups\_instance\_types](#input\_node\_groups\_instance\_types) | Node group EC2 instances type. | `list(string)` | <pre>[<br>  "m5.large"<br>]</pre> | no |
| <a name="input_node_groups_max_capacity"></a> [node\_groups\_max\_capacity](#input\_node\_groups\_max\_capacity) | Node group Max capacity. | `number` | `10` | no |
| <a name="input_node_groups_min_capacity"></a> [node\_groups\_min\_capacity](#input\_node\_groups\_min\_capacity) | Node group Min capacity. | `number` | `1` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnets. | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of public subnets. | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region. | `string` | `"us-east-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_tags_map"></a> [tags\_map](#input\_tags\_map) | A map of tags to add to all resources. Tags added to launch configuration or templates override these values for ASG Tags only. | `map(string)` | `{}` | no |
| <a name="input_vpc-cni_addon_enabled"></a> [vpc-cni\_addon\_enabled](#input\_vpc-cni\_addon\_enabled) | Enable vpc-cni EKS addon. | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id to be used for EKS cluster deployment | `string` | n/a | yes |
| <a name="input_wait_for_cluster_cmd"></a> [wait\_for\_cluster\_cmd](#input\_wait\_for\_cluster\_cmd) | Custom local-exec command to execute for determining if the eks cluster is healthy. Cluster endpoint will be available as an environment variable called ENDPOINT | `string` | `"for i in `seq 1 60`; do wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null && exit 0 || true; sleep 10; done; echo TIMEOUT && exit 1"` | no |
| <a name="input_wait_for_cluster_interpreter"></a> [wait\_for\_cluster\_interpreter](#input\_wait\_for\_cluster\_interpreter) | Custom local-exec command line interpreter for the command to determining if the eks cluster is healthy. | `list(string)` | <pre>[<br>  "/bin/sh",<br>  "-c"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | EKS cluster ARN |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | EKS cluster endpoint |
| <a name="output_cluster_iam_role_arn"></a> [cluster\_iam\_role\_arn](#output\_cluster\_iam\_role\_arn) | EKS cluster IAM role ARN |
| <a name="output_cluster_iam_role_name"></a> [cluster\_iam\_role\_name](#output\_cluster\_iam\_role\_name) | EKS cluster IAM role name |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | EKS cluster ID |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | EKS cluster primary SG ID |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | EKS cluster SG ID |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | EKS cluster OIDC provider ARN |
| <a name="output_worker_security_group_id"></a> [worker\_security\_group\_id](#output\_worker\_security\_group\_id) | EKS workers SG ID |
