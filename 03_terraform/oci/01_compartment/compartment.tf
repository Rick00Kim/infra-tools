# DEFINE VARIABLES
variable root_compartment_id {
  description = "ID of the root compartment"
  type        = string
}
variable target_compartment_name { }
variable target_description { }

# CREATE RESOURCE
# Compartment
resource "oci_identity_compartment" "tf-compartment" {
    # Required
    compartment_id = var.root_compartment_id
    description = var.target_description
    name = var.target_compartment_name
}
