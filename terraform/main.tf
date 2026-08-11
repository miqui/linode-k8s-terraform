data "linode_lke_versions" "available" {}

locals {
  k8s_version = var.k8s_version != "" ? var.k8s_version : data.linode_lke_versions.available.versions[0].id
}

resource "linode_lke_cluster" "this" {
  label       = var.cluster_label
  region      = var.region
  k8s_version = local.k8s_version
  tags        = ["demo-dev", "managed-by-terraform"]

  pool {
    type  = var.node_type
    count = var.node_count
  }
}
