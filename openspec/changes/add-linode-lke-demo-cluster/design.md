## Context

See proposal.md - Why. This is a greenfield repo: no existing Terraform code, state, or CI. The module targets Linode's managed Kubernetes offering (LKE) rather than self-managed nodes, so the control plane is entirely Linode-operated and out of scope for this module.

## Goals / Non-Goals

**Goals:**
- A single Terraform root module that creates one LKE cluster with one small node pool.
- Sensible demo/dev defaults so `terraform apply` with no variable overrides produces a usable, low-cost cluster.
- Clear, documented path to get kubeconfig and tear the cluster back down.

**Non-Goals:**
- Remote state backend/locking (state stays local for this change; a demo/dev cluster's state is disposable).
- Multiple node pools, autoscaling, or high availability control plane.
- Custom VPC/VLAN, firewall rules, or ingress controller installation.
- CI/CD pipeline to run Terraform automatically.

## Decisions

- **LKE over self-managed nodes**: Use `linode_lke_cluster` (Linode Terraform provider) instead of provisioning bare `linode_instance` resources and bootstrapping kubeadm/k3s. Rationale: LKE's control plane is free and managed by Linode, which minimizes both the Terraform surface area and ongoing operational burden for a demo/dev use case. Alternative (self-managed) was explicitly rejected by the user for this change - it's a valid future path if more control over the control plane is needed.
- **Single node pool, small instance type**: Default to one `linode_lke_cluster` node pool using a small shared-CPU plan (`g6-standard-2`: 2 vCPU / 4GB) with a default count of 2 nodes. Rationale: keeps idle/demo cost low while still giving enough capacity to schedule a handful of demo workloads and tolerate one node restart. Node type/count are variables so users can size up for heavier demos without module changes.
- **Local Terraform state**: No remote backend is configured; state defaults to local `terraform.tfstate`. Rationale: matches the disposable, single-operator nature of a demo/dev cluster; avoids requiring an Object Storage bucket or Linode-hosted state backend just to try the module. Documented as a known limitation - team/shared use should add a remote backend.
- **Token via `TF_VAR_linode_token`**: The Linode provider is configured with `token = var.linode_token`, and `linode_token` is declared `sensitive = true` with no default. Rationale: keeps the token out of `.tfvars` files that might accidentally get committed, and out of Terraform plan/apply console output.
- **Kubeconfig output marked sensitive**: The `linode_lke_cluster` resource's `kubeconfig` attribute is surfaced as a `sensitive = true` Terraform output; README documents decoding it (it's base64-encoded by the provider) and writing it to a file, e.g. `terraform output -raw kubeconfig | base64 -d > kubeconfig.yaml`.

## Risks / Trade-offs

- [Local state has no locking or backup] → Acceptable for single-operator demo/dev; README calls out that losing `terraform.tfstate` orphans the cluster (must be cleaned up manually via Linode Cloud Manager or `linode-cli`) and recommends not sharing the module directory between concurrent users.
- [Default node type/count still incurs hourly Linode billing while running] → README instructs running `terraform destroy` when the cluster isn't in active use; defaults are chosen to be the lowest reasonable cost, not free.
- [No firewall/network hardening by default] → Acceptable for demo/dev scope; explicitly called out as a non-goal so it isn't mistaken for a production-ready posture.

## Migration Plan

Not applicable - this is a net-new module in a greenfield repo with no prior infrastructure or state to migrate.
