# linode-lke-cluster Specification

## Purpose

Provisions and tears down a demo/dev-sized Kubernetes cluster on Linode Kubernetes Engine (LKE) through Terraform, so a working cluster is a single `terraform apply` away and fully disposable via `terraform destroy`.

## Requirements

### Requirement: Terraform provisions an LKE cluster
The system SHALL provision a Linode Kubernetes Engine (LKE) cluster using the Linode Terraform provider when `terraform apply` is run with valid credentials.

#### Scenario: Successful cluster creation
- **WHEN** a user runs `terraform apply` with a valid Linode API token and default variable values
- **THEN** Terraform creates an LKE cluster with one node pool in the configured region and Kubernetes version

#### Scenario: Missing API token
- **WHEN** a user runs `terraform apply` without setting the Linode API token variable
- **THEN** Terraform fails before creating any Linode resources, with an error identifying the missing token variable

### Requirement: Demo/dev-sized default configuration
The system SHALL default to a minimal, low-cost cluster topology suitable for demos and local development: a single node pool of small Linode instance types, sized small enough to avoid production-grade cost by default.

#### Scenario: Default apply produces a small single-pool cluster
- **WHEN** a user runs `terraform apply` without overriding node type, node count, or region variables
- **THEN** the resulting cluster has exactly one node pool using the module's default low-cost Linode instance type and a small default node count (no more than 3 nodes)

### Requirement: Configurable cluster inputs
The system SHALL expose region, Kubernetes version, node type, node count, and cluster label as Terraform input variables, each with a demo/dev-appropriate default value.

#### Scenario: Overriding node count and type
- **WHEN** a user sets non-default values for the node type and node count variables and runs `terraform apply`
- **THEN** the created cluster's node pool uses the overridden node type and node count instead of the defaults

### Requirement: Kubeconfig and endpoint outputs
The system SHALL output the cluster's kubeconfig content and API server endpoint after a successful apply, so a user can connect with `kubectl` without visiting the Linode Cloud Manager.

#### Scenario: Retrieving kubeconfig after apply
- **WHEN** `terraform apply` completes successfully
- **THEN** `terraform output` exposes a kubeconfig value that can be written to a file and used to authenticate `kubectl` against the new cluster, and an output exposing the cluster's API endpoint

### Requirement: API token not stored in the repo
The system SHALL source the Linode API token from an externally-supplied Terraform variable (for example, an environment variable or `.tfvars` file excluded from version control) and SHALL NOT hardcode or commit the token.

#### Scenario: Token supplied via environment variable
- **WHEN** a user sets `TF_VAR_linode_token` in their shell environment and runs `terraform apply`
- **THEN** Terraform uses that value to authenticate to the Linode API without the token appearing in any versioned file

### Requirement: Full teardown via destroy
The system SHALL allow the entire cluster and its node pool to be deleted with a single `terraform destroy`, leaving no orphaned Linode LKE resources managed by this module.

#### Scenario: Tearing down the cluster
- **WHEN** a user runs `terraform destroy` against a previously applied state
- **THEN** the LKE cluster and its node pool are deleted from the Linode account and no longer appear in `terraform state list`
