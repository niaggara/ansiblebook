variable "arm_subscription_id" {
  type        = string
  default     = "${env("ARM_SUBSCRIPTION_ID")}"
  description = "https://www.packer.io/docs/builders/azure/arm"
}

variable "arm_location" {
  type        = string
  default     = "westeurope"
  description = "https://azure.microsoft.com/en-us/global-infrastructure/geographies/"
}

variable "arm_resource_group" {
  type        = string
  default     = "${env("ARM_RESOURCE_GROUP")}"
  description = "make arm-resourcegroup in Makefile"
}

variable "arm_storage_account" {
  type        = string
  default     = "${env("ARM_STORAGE_ACCOUNT")}"
  description = "make arm-storageaccount in Makefile"
}

variable "image" {
  type        = string
  default     = "centos7"
  description = "Name of the image when created"
}

source "azure-arm" "arm_image" {
  azure_tags = {
    product = "${var.image}"
  }
  image_offer                       = "CentOS"
  image_publisher                   = "OpenLogic"
  image_sku                         = "7.7"
  location                          = "${var.arm_location}"
  managed_image_name                = "${var.image}"
  managed_image_resource_group_name = "${var.arm_resource_group}"
  os_disk_size_gb                   = "30"
  os_type                           = "Linux"
  subscription_id                   = "${var.arm_subscription_id}"
  vm_size                           = "Standard_D8_v3"
}

build {
  sources = ["source.azure-arm.arm_image"]

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    scripts         = ["scripts/ansible.sh"]
  }


  provisioner "ansible-local" {
    extra_arguments = ["--extra-vars \"image=${var.image}\""]
    playbook_dir    = "./ansible"
    playbook_file   = "ansible/playbook.yml"
  }

  provisioner "shell" {
    execute_command = "{{ .Vars }} /usr/bin/sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/cleanup.sh"
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
  }

}
