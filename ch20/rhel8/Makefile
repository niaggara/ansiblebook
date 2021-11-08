
lint:
	vagrant validate
	packer validate rhel8.pkr.hcl
	ansible-inventory --graph
	ansible-lint packer-playbook.yml vagrant-playbook.yml
	ansible-later
	shellcheck scripts/*

clean: lint
	@vagrant destroy -f
	@vagrant box remove RedHat-EL8 || /usr/bin/true
	@rm -rf output-rhel8

output-rhel8/rhel8.box:
	packer build rhel8.pkr.hcl

virtualbox: output-rhel8/rhel8.box
	vagrant box add --force --name RedHat-EL8 output-rhel8/rhel8.box
	vagrant up rhel8

