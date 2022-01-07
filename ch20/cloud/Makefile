ARM_LOCATION ?= westeurope

help:
	@echo 'available make targets:'
	@grep PHONY: Makefile | cut -d: -f2 | sed '1d;s/^/make/'

.PHONY: galaxy                   # Local - Install Ansible roles
galaxy:
	(cd ansible && ansible-galaxy install -f -p roles -r roles/requirements.yml)

.PHONY: aws-image                # AWS   - Create AMI with Packer
ifndef AWS_ACCESS_KEY_ID
	$(error AWS_ environment variables not set)
endif
aws-image:
	packer build -force aws.pkr.hcl

.PHONY: gcp-image                # GCP   - Create VM image with Packer
ifndef GCP_PROJECT_ID
	$(error GCP_PROJECT_ID should be exported as environment variable)
else
	@echo GCP_PROJECT_ID=${GCP_PROJECT_ID}
endif
gcp-image:
	packer build -force gcp.pkr.hcl

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
	packer build -force azure.pkr.hcl

