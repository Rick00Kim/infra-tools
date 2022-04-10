# Oracle Cloud Infrastructure (OCI)

Create OCI components using Terraform

## Common setting

- Variables file

  Create .tfvars, then It will be loaded when execute terraform.

### 1. Compartment

   path: ./01_compartment/compartment.tf

### 2. VCN

   path: ./02_vcn/vcn.tf

### 3. Instance

   precondition: Created compartment
   path: ./03_compute_instance/instance.tf

