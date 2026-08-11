resource "linode_lke_cluster" "this" {
  label       = var.cluster_label
  region      = var.region
  k8s_version = var.k8s_version
  tags        = ["demo-dev", "managed-by-terraform"]

  pool {
    type  = var.node_type
    count = var.node_count
  }
}
