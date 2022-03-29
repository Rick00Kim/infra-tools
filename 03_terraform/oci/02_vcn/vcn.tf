# DEFINE VARIABLES
variable target_compartment_id { }
variable target_region { }

# CREATE RESOURCE
# VCN (Virtual Cloud Network)
module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.3.0"
  # Required Inputs
  compartment_id = var.target_compartment_id
  region = var.target_region

  internet_gateway_route_rules = null
  local_peering_gateways = null
  nat_gateway_route_rules = null

  # Optional Inputs
  vcn_name = "vcn_kururu_monitoring"
  vcn_dns_label = "vcnmonitor"
  vcn_cidrs = ["10.0.0.0/16"]
  
  create_internet_gateway = true
  create_nat_gateway = true
  create_service_gateway = true  
}