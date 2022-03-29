# DEFINE VARIABLES
variable root_compartment_id {
  description = "ID of the root compartment"
  type        = string
}

# CREATE RESOURCE
# Compartment
resource "oci_identity_compartment" "tf-compartment" {
    # Required
    compartment_id = var.root_compartment_id
    description = "Compartment for Monitoring."
    name = "kururu-monitoring"
}
