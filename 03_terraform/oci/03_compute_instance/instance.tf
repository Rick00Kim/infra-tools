# DEFINE VARIABLES
variable target_compartment_id { }
variable target_region { default = "ap-tokyo-1" }
variable target_availability_domain { default = "KWby:AP-TOKYO-1-AD-1" }
variable target_image_id { default = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaaiqnzylthf6siyhwrnwu7fzci2clbp4rpdtuok6byikb727nklc5q" }
variable target_subnet_id { }
variable target_ssh_file_path { }
variable target_instance_name { }

# CREATE RESOURCE
# VM Instance
resource "oci_core_instance" "target_instance" {
    # Required
    availability_domain = var.target_availability_domain
    compartment_id = var.target_compartment_id
    shape = "VM.Standard.A1.Flex"
    source_details {
        source_id = var.target_image_id
        source_type = "image"
    }

    # Optional
    display_name = var.target_instance_name
    shape_config {
        memory_in_gbs             = "8"
        ocpus                     = "1"
    }
    create_vnic_details {
        assign_public_ip = true
        subnet_id = var.target_subnet_id
    }
    metadata = {
        ssh_authorized_keys = file(var.target_ssh_file_path)
    } 
}
