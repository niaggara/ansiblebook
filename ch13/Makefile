lint:
	vagrant validate
	packer validate rhel8.pkr.hcl
	packer validate gcc.pkr.hcl
	ansible-inventory  --graph
	ansible-playbook --syntax-check playbooks/*.yml
	ansible-lint playbooks/*.yml
	ansible-later
	shellcheck scripts/*

clean:
	@vagrant destroy -f
	@vagrant box remove RedHat-EL8 || /usr/bin/true
	@rm -rf output-rhel8

box: clean
	packer build rhel8.pkr.hcl

vagrant:
	vagrant box add --name RedHat-EL8 output-rhel8/rhel8.box
	vagrant up

container: lint
	@packer init .
	packer build gcc.pkr.hcl

vm: clean lint box vagrant

all: container vm
