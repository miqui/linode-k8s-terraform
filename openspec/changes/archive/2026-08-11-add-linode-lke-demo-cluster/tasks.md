## 1. Module scaffolding

- [x] 1.1 Create Terraform root module directory (e.g. `terraform/`) with `versions.tf` declaring required Terraform version and the `linode/linode` provider version constraint
- [x] 1.2 Add `provider "linode"` block configured with `token = var.linode_token`

## 2. Input variables

- [x] 2.1 Declare `linode_token` variable (`sensitive = true`, no default)
- [x] 2.2 Declare `region` variable with a demo/dev-friendly default (e.g. `us-mia`)
- [x] 2.3 Declare `k8s_version` variable defaulting to a current stable LKE-supported Kubernetes version
- [x] 2.4 Declare `node_type` variable defaulting to a small shared-CPU plan (e.g. `g6-standard-2`)
- [x] 2.5 Declare `node_count` variable defaulting to `2`
- [x] 2.6 Declare `cluster_label` variable defaulting to a demo/dev-identifiable name (e.g. `demo-dev-cluster`)

## 3. Cluster resource

- [x] 3.1 Define `linode_lke_cluster` resource using `var.region`, `var.k8s_version`, and `var.cluster_label`
- [x] 3.2 Define the cluster's single node pool block using `var.node_type` and `var.node_count`
- [x] 3.3 Tag the cluster/resources to make demo/dev purpose and ownership identifiable in the Linode Cloud Manager

## 4. Outputs

- [x] 4.1 Add `kubeconfig` output sourced from the cluster resource, marked `sensitive = true`
- [x] 4.2 Add `api_endpoint` (or equivalent) output exposing the cluster's API server endpoint
- [x] 4.3 Add `cluster_id` output exposing the LKE cluster ID for reference/debugging

## 5. Documentation

- [x] 5.1 Write module README covering: prerequisites (Linode account, API token, Terraform installed), how to set `TF_VAR_linode_token`, and `terraform init/plan/apply/destroy` usage
- [x] 5.2 Document how to decode and use the kubeconfig output with `kubectl` (e.g. `terraform output -raw kubeconfig | base64 -d > kubeconfig.yaml`)
- [x] 5.3 Document cost/teardown expectations: cluster bills while running, `terraform destroy` removes it, local state file is the source of truth and should not be deleted while the cluster exists
- [x] 5.4 Add `.gitignore` entries for `*.tfstate*`, `.terraform/`, and any local `*.tfvars` files to avoid committing state or secrets

## 6. Validation

- [x] 6.1 Run `terraform fmt` and `terraform validate` against the module
- [x] 6.2 Run `terraform plan` with default variables and confirm it plans exactly one `linode_lke_cluster` with one node pool
- [x] 6.3 Run `terraform apply` against a real Linode account, confirm `kubectl` connectivity using the kubeconfig output, then `terraform destroy` and confirm the cluster no longer appears in `terraform state list` or the Linode Cloud Manager
