variable "gcp_project_id" {
  type        = string
  default     = "${env("GCP_PROJECT_ID")}"
  description = "Create a project and use the project-id"
}

variable "gcp_region" {
  type        = string
  default     = "${env("CLOUDSDK_COMPUTE_REGION")}"
  description = "https://console.cloud.google.com/compute/settings"
}

variable "gcp_zone" {
  type        = string
  default     = "${env("CLOUDSDK_COMPUTE_ZONE")}"
  description = "https://console.cloud.google.com/compute/settings"
}

variable "gcp_centos_image" {
  type        = string
  default     = "centos-7-v20211105"
  description = ""
}

variable "image" {
  type        = string
  default     = "centos7"
  description = "Name of the image when created"
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
  sources = ["googlecompute.gcp_image"]

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

}
