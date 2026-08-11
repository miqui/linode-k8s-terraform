## Why

There is currently no Infrastructure-as-Code in this repo for standing up a Kubernetes cluster on Linode. A demo/dev environment needs to be created and torn down quickly and cheaply, without hand-clicking through the Linode Cloud Manager, so the team can spin up disposable clusters for demos, testing, and local development against a real cluster.

## What Changes

- Add a Terraform root module that provisions a Linode Kubernetes Engine (LKE) cluster via the official `linode/linode` Terraform provider (`linode_lke_cluster` resource).
- Size the cluster for demo/dev usage by default: a single node pool with a small number of low-cost Linode instance types (e.g. `g6-standard-2`), not a production-grade multi-pool, high-availability layout.
- Expose the key inputs (Linode API token, region, Kubernetes version, node type, node count, cluster label) as Terraform variables with sensible demo/dev defaults, so the cluster can be customized without editing the module.
- Output the cluster's kubeconfig and API endpoint so a user can immediately `kubectl` into the cluster after `terraform apply`.
- Store the Linode API token via a Terraform variable sourced from the environment (`TF_VAR_linode_token`) rather than committed to the repo.
- Document prerequisites and usage (`terraform init/plan/apply/destroy`) in a README for the module.
- Explicitly out of scope: high-availability control plane, multiple node pools, autoscaling, custom VPC/VLAN networking, Terraform remote state backend/locking, and CI/CD automation. These can be follow-up changes if the demo/dev cluster needs to graduate toward production use.

## Capabilities

### New Capabilities
- `linode-lke-cluster`: Terraform-managed provisioning of a demo/dev-sized Linode LKE Kubernetes cluster, including its node pool sizing, configurable inputs, and kubeconfig/endpoint outputs.

### Modified Capabilities
(none - greenfield repo)

## Impact

- New Terraform code under the repo (provider config, variables, resources, outputs, README) - no existing code is affected since this is a greenfield repo.
- New dependency: Linode Terraform provider (`linode/linode`) and a Linode account API token (user-supplied, not stored in the repo).
- Introduces a new deployable resource (billable Linode LKE cluster + node pool) that incurs cost while running; `terraform destroy` is the expected way to tear it down after demo/dev use.
