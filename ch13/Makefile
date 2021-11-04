lint:
	vagrant validate
	packer validate rhel8.pkr.hcl
	packer validate gcc.pkr.hcl
	ansible-lint playbooks/*.yml
	ansible-later

clean:
	@vagrant destroy -f
	@vagrant box remove RedHat-EL8 || /usr/bin/true
	@rm -rf output-rhel8

box: clean
	packer build rhel8.pkr.hcl

vagrant:
	vagrant box add --name RedHat-EL8 output-rhel8/rhel8.box
	vagrant up

container:
	@packer init .
	packer build gcc.pkr.hcl

vm: clean box vagrant
