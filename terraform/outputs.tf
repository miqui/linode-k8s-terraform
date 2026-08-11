output "kubeconfig" {
  description = "Base64-encoded kubeconfig for the cluster. Decode with: terraform output -raw kubeconfig | base64 -d > kubeconfig.yaml"
  value       = linode_lke_cluster.this.kubeconfig
  sensitive   = true
}

output "api_endpoint" {
  description = "API server endpoint(s) for the cluster."
  value       = linode_lke_cluster.this.api_endpoints
}

output "cluster_id" {
  description = "ID of the LKE cluster."
  value       = linode_lke_cluster.this.id
}
