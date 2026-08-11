# Linode LKE demo/dev cluster

Terraform module that provisions a small [Linode Kubernetes Engine (LKE)](https://www.linode.com/products/kubernetes/) cluster sized for demos and local development: one node pool of low-cost instances, no HA control plane, no remote state backend.

Not intended for production use - see `openspec/changes/add-linode-lke-demo-cluster/design.md` for the scope and trade-offs.

## Prerequisites

- A [Linode account](https://www.linode.com) and a [Personal Access Token](https://cloud.linode.com/profile/tokens) with read/write access to Kubernetes (LKE) and Linodes.
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0.
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) to interact with the cluster once it's up.

## Usage

Set your Linode API token as an environment variable so it never lands in a file:

```bash
export TF_VAR_linode_token="your-linode-api-token"
```

Initialize, review, and apply:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

By default this creates a cluster labeled `demo-dev-cluster` in region `us-mia` with one node pool of 2x `g6-standard-2` nodes running the latest supported Kubernetes version on Linode LKE. Override any of `region`, `k8s_version`, `node_type`, `node_count`, or `cluster_label` via `-var` flags, a `*.tfvars` file, or environment variables (`TF_VAR_<name>`) to customize.

### Connecting with kubectl

The cluster's kubeconfig is exposed as a sensitive Terraform output, base64-encoded by the provider. Decode it to a file and point `kubectl` at it:

```bash
terraform output -raw kubeconfig | base64 -d > kubeconfig.yaml
export KUBECONFIG="$(pwd)/kubeconfig.yaml"
kubectl get nodes
```

The cluster's API endpoint(s) are available via:

```bash
terraform output api_endpoint
```

## Cost and teardown

The cluster and its node pool bill hourly while they exist. When you're done with a demo/dev session, tear everything down:

```bash
terraform destroy
```

This is the expected way to reclaim cost between sessions - the module keeps no remote state, so `terraform.tfstate` (created locally by `terraform init`/`apply`) is the only record of what Terraform manages. Don't delete `terraform.tfstate` while the cluster still exists, or you'll orphan it and have to clean it up manually via the [Linode Cloud Manager](https://cloud.linode.com/kubernetes/clusters) or `linode-cli`. Because state is local, avoid running this module from more than one machine/session against the same cluster at a time.

**NodeBalancers and volumes aren't tracked by Terraform.** If you deployed a Kubernetes `Service` of type `LoadBalancer` (or anything that creates one, like an ingress controller) or created `PersistentVolumeClaim`s, Linode's Cloud Controller Manager provisions the backing NodeBalancer/Volume directly via the Linode API - outside Terraform's state. `terraform destroy` only removes the cluster and node pool it manages, so these keep billing after destroy. Run `kubectl delete svc --all` (and delete any PVCs) before `terraform destroy`, or check the [Linode Cloud Manager](https://cloud.linode.com/nodebalancers) afterward for orphans.
