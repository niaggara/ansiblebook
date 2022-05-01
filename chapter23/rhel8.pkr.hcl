variable "iso_url1" {
  type    = string
  default = "file:///Users/Shared/rhel-8.4-x86_64-dvd.iso"
}

variable "iso_url2" {
  type    = string
  default = "https://developers.redhat.com/content-gateway/file/rhel-8.4-x86_64-dvd.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:48f955712454c32718dcde858dea5aca574376a1d7a4b0ed6908ac0b85597811"
}

variable "version" {
  type    = string
  default = "8.4.${env("DATE")}"
}

source "virtualbox-iso" "rhel8" {
  boot_command            = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"]
  boot_wait               = "5s"
  cpus                    = 2
  disk_size               = 65536
  guest_os_type           = "RedHat_64"
  hard_drive_interface    = "sata"
  headless                = true
  http_directory          = "kickstart"
  iso_checksum            = "${var.iso_checksum}"
  iso_urls                = ["${var.iso_url1}", "${var.iso_url2}"]
  memory                  = 4096
  shutdown_command        = "echo 'vagrant' | sudo -S /sbin/halt -h -p"
  ssh_password            = "vagrant"
  ssh_port                = 22
  ssh_username            = "root"
  ssh_wait_timeout        = "10000s"
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "RedHat-EL8"
}

build {
  sources = ["source.virtualbox-iso.rhel8"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    scripts         = ["scripts/vagrant.sh", "scripts/cleanup.sh"]
  }

  post-processors {
    post-processor "vagrant" {
      keep_input_artifact  = true
      compression_level    = 9
      output               = "output-rhel8/rhel8.box"
      vagrantfile_template = "Vagrantfile.template"
    }
  }
}
