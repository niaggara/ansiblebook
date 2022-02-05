locals {
  version = "0.0.1"
}
variable "version" {
  type    = string
  default = "0.0.1"
}

variable "iso_url1" {
  type    = string
  default = "file:///Users/Shared/Rocky-8.5-x86_64-dvd1.iso"
}

variable "iso_url2" {
  type    = string
  default = "https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.5-x86_64-dvd1.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:0081f8b969d0cef426530f6d618b962c7a01e71eb12a40581a83241f22dfdc25"
}

variable "vagrant_cloud_user" {
  type    = string
  default = "${env("VAGRANT_CLOUD_USER")}"
}

variable "vagrant_cloud_token" {
  type    = string
  default = "${env("VAGRANT_CLOUD_TOKEN")}"
}

source "virtualbox-iso" "bastion" {
  boot_command           = ["<tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"]
  boot_wait              = "5s"
  cpus                   = 2
  disk_size              = 65536
  gfx_controller         = "vmsvga"
  gfx_efi_resolution     = "1920x1080"
  gfx_vram_size          = "128"
  guest_os_type          = "RedHat_64"
  guest_additions_mode   = "upload"
  hard_drive_interface   = "sata"
  headless               = true
  http_directory         = "kickstart"
  iso_checksum           = "${var.iso_checksum}"
  iso_urls               = ["${var.iso_url1}", "${var.iso_url2}"]
  memory                 = 4096
  nested_virt            = true
  shutdown_command       = "echo 'vagrant' | sudo -S /sbin/halt -h -p"
  ssh_password           = "vagrant"
  ssh_username           = "vagrant"
  ssh_wait_timeout       = "10000s"
  rtc_time_base          = "UTC"
  virtualbox_version_file= ".vbox_version"
  vrdp_bind_address      = "0.0.0.0"
  vrdp_port_min          = "5900"
  vrdp_port_max          = "5900"
  vm_name                = "Bastion"
}

build {
  sources = ["source.virtualbox-iso.bastion"]

  provisioner "ansible" {
    playbook_file   = "playbooks/playbook.yml"
  }

  post-processors {
    post-processor "vagrant" {
      keep_input_artifact  = true
      compression_level    = 9
      output               = "output-vagrant/vagrant.box"
  }
  post-processor "vagrant-cloud" {
      access_token = "${var.vagrant_cloud_token}"
      box_tag      = "${var.vagrant_cloud_user}/Bastion"
      version      = "${local.version}"
    }
  }
}
