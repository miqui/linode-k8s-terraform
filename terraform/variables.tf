variable "linode_token" {
  description = "Linode API token used to authenticate with the Linode API. Set via TF_VAR_linode_token."
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Linode region to provision the LKE cluster in."
  type        = string
  default     = "us-mia"
}

variable "k8s_version" {
  description = "Kubernetes version for the LKE cluster."
  type        = string
  default     = "1.31"
}

variable "node_type" {
  description = "Linode instance type used for the cluster's node pool."
  type        = string
  default     = "g6-standard-2"
}

variable "node_count" {
  description = "Number of nodes in the cluster's node pool."
  type        = number
  default     = 2
}

variable "cluster_label" {
  description = "Label for the LKE cluster, used to identify it in the Linode Cloud Manager."
  type        = string
  default     = "demo-dev-cluster"
}
