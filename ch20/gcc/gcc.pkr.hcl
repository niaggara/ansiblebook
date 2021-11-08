packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "gcc" {
  changes     = ["CMD [\"/bin/bash\"]", "ENTRYPOINT [\"\"]"]
  commit = true
  image  = "centos:7"
  run_command = ["-d", "-i", "-t", "--network=host", "--entrypoint=/bin/sh", "--", "{{ .Image }}"]
}

build {
  name    = "docker-gcc"
  sources = [
    "source.docker.gcc"
  ]

  provisioner "shell" {
    inline = ["yum -y install sudo"]
  }

  provisioner "ansible" {
    playbook_file = "./playbook.yml"
    galaxy_file   = "./roles/requirements.yml"
  }

  post-processors {
    post-processor "docker-tag" {
        repository =  "localhost/gcc11-centos7"
        tags = ["0.1"]
      }
  }
}
