ARM_LOCATION ?= westeurope

help:
	@echo 'available make targets:'
	@grep PHONY: Makefile | cut -d: -f2 | sed '1d;s/^/make/'

.PHONY: galaxy                   # Local - Install Ansible roles
galaxy:
	(cd ansible && ansible-galaxy install -f -p roles -r roles/requirements.yml)

.PHONY: vagrant-vm               # Vagrant - Create a VirtualBox VM
vagrant-vm:
	vagrant up --no-provision

.PHONY: vagrant-provision        # Vagrant - Provision VirtualBox VM
vagrant-provision:
	vagrant provision

.PHONY: arm-resourcegroup        # Azure - create resource groups in ${ARM_LOCATION}
arm-resourcegroup:
ifndef ARM_RESOURCE_GROUP
	$(error ARM_RESOURCE_GROUP and ARM_LOCATION should be exported as environment variables)
else
	@echo ARM_RESOURCE_GROUP=${ARM_RESOURCE_GROUP}
endif
	az group create -l "${ARM_LOCATION}" -n "${ARM_RESOURCE_GROUP}"

.PHONY: arm-storageaccount       # Azure - create ${ARM_STORAGE_ACCOUNT} in ${ARM_LOCATION}
arm-storageaccount:
ifndef ARM_STORAGE_ACCOUNT
	$(error lowercase ARM_STORAGE_ACCOUNT not exported as environment variable)
else
	@echo ARM_STORAGE_ACCOUNT=${ARM_STORAGE_ACCOUNT}
endif
	az storage account create -n "${ARM_STORAGE_ACCOUNT}" \
		-g ${ARM_RESOURCE_GROUP} -l ${ARM_LOCATION} --sku Premium_LRS --https-only true

.PHONY: arm-image                # Azure - Create VM image with Packer
arm-image:
	@echo arm-centos-image
	/usr/local/bin/packer build -force -only=azure-arm.arm_image bastion.pkr.hcl

.PHONY: clean                    # Local - Cleanup dev environment
clean:
	vagrant destroy -f
	rm -rf .vagrant packer/* packer_cache/* output-virtualbox-iso/*
