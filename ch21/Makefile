AWS_REGION ?= eu-central-1

help:
	@echo 'available make targets:'
	@grep PHONY: Makefile | cut -d: -f2 | sed '1d;s/^/make/'

.PHONY: galaxy                   # Local   - Install Ansible roles
galaxy:
	(cd playbooks && ansible-galaxy install -p roles -r roles/requirements.yml)

.PHONY: lint                     # Local   - Validate files
lint: galaxy
	python3 --version
	ansible-playbook --version
	ansible-playbook --syntax-check playbooks/*.yml
	(cd playbooks && ansible-inventory --list|jq -r .aws_ec2)
	git ls-files *.yml | xargs yamllint
	ansible-lint playbooks/*.yml
	packer -version
	packer validate ec2.pkr.hcl
	shellcheck scripts/*.sh
	pylint *.py


.PHONY: ec2-image                # AWS EC2 - Create VM image with Packer
ifndef AWS_ACCESS_KEY_ID
	$(error AWS_ACCESS_KEY_ID should be exported as environment variable)
endif
ifndef AWS_SECRET_ACCESS_KEY
	$(error AWS_SECRET_ACCESS_KEY should be exported as environment variable)
endif
ec2-image: galaxy lint
	packer build -force ec2.pkr.hcl

