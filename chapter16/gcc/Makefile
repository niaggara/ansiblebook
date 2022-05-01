lint:
	packer validate gcc.pkr.hcl
	ansible-lint playbook.yml
	ansible-later
	docker info

container: lint
	packer init .
	packer build gcc.pkr.hcl

all: container

