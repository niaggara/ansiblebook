
variable "arm_client_id" {
  type        = string
  default     = "${env("ARM_CLIENT_ID")}"
  description = ""
}

variable "arm_client_secret" {
  type        = string
  default     = "${env("ARM_CLIENT_SECRET")}"
  description = ""
}

variable "arm_image_sku" {
  type        = string
  default     = "7.7"
  description = ""
}

variable "arm_location" {
  type        = string
  default     = "${env("ARM_LOCATION")}"
  description = ""
}

variable "arm_resource_group" {
  type        = string
  default     = "${env("ARM_RESOURCE_GROUP")}"
  description = ""
}

variable "arm_storage_account" {
  type        = string
  default     = "${env("ARM_STORAGE_ACCOUNT")}"
  description = ""
}

variable "arm_subscription_id" {
  type        = string
  default     = "${env("ARM_SUBSCRIPTION_ID")}"
  description = ""
}

variable "arm_tenant_id" {
  type        = string
  default     = "${env("ARM_TENANT_ID")}"
  description = ""
}

variable "gcp_centos_image" {
  type        = string
  default     = "centos-7-v20211105"
  description = ""
}

variable "gcp_project_id" {
  type        = string
  default     = "${env("GCP_PROJECT_ID")}"
  description = ""
}

variable "gcp_region" {
  type        = string
  default     = "${env("CLOUDSDK_COMPUTE_REGION")}"
  description = ""
}

variable "gcp_zone" {
  type        = string
  default     = "${env("CLOUDSDK_COMPUTE_ZONE")}"
  description = ""
}

variable "git_tag" {
  type        = string
  default     = "${env("GIT_TAG")}"
  description = ""
}

variable "image" {
  type        = string
  default     = "centos7"
  description = ""
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

locals {
  version = "7.7.${local.timestamp}"
}

source "azure-arm" "arm_image" {
  azure_tags = {
    product = "${var.image}"
  }
  client_id                         = "${var.arm_client_id}"
  client_secret                     = "${var.arm_client_secret}"
  image_offer                       = "CentOS"
  image_publisher                   = "OpenLogic"
  image_sku                         = "${var.arm_image_sku}"
  location                          = "${var.arm_location}"
  managed_image_name                = "${var.image}"
  managed_image_resource_group_name = "${var.arm_resource_group}"
  os_disk_size_gb                   = "30"
  os_type                           = "Linux"
  subscription_id                   = "${var.arm_subscription_id}"
  tenant_id                         = "${var.arm_tenant_id}"
  vm_size                           = "Standard_D8_v3"
}

source "googlecompute" "gcp_image" {
  disk_size     = "30"
  image_family  = "centos-7"
  image_name    = "${var.image}"
  machine_type  = "e2-standard-2"
  project_id    = "${var.gcp_project_id}"
  region        = "${var.gcp_region}"
  source_image  = "${var.gcp_centos_image}"
  ssh_username  = "centos"
  state_timeout = "20m"
  zone          = "${var.gcp_zone}"
}

build {
  sources = ["source.azure-arm.arm_image", "googlecompute.gcp_image"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    scripts         = ["scripts/ansible.sh"]
  }

  provisioner "ansible-local" {
    extra_arguments = ["--extra-vars \"image=${var.image}\""]
    playbook_dir    = "./ansible"
    playbook_file   = "ansible/packer.yml"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} /usr/bin/sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/cleanup.sh"
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
    only            = ["azure-arm"]
  }

}
