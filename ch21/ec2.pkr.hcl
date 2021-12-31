variable "aws_region" {
  type        = string
  default     = "${env("AWS_REGION")}"
  description = "https://docs.aws.amazon.com/general/latest/gr/rande.html"
}

variable "aws_centos_image" {
  type        = string
  default     = "ami-0e8286b71b81c3cc1"
  description = "https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html"
}

variable "image" {
  type        = string
  default     = "centos7"
  description = "Name of the image when created"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "aws_image" {
  ami_name      = "${var.image}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "${var.aws_region}"
  source_ami    = "${var.aws_centos_image}"
  ssh_username  = "centos"
  tags = {
    Name = "${var.image}"
  }
}

build {
  sources = ["source.amazon-ebs.aws_image"]

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    scripts         = ["scripts/ansible.sh"]
  }

  provisioner "ansible-local" {
    extra_arguments = ["--extra-vars \"image=${var.image}\""]
    playbook_dir    = "./playbooks"
    playbook_file   = "playbooks/packer.yml"
  }

  provisioner "shell" {
    execute_command = "{{ .Vars }} /usr/bin/sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/cleanup.sh"
  }

}
