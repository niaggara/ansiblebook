# type 'make' for help with this Makefile

.PHONY: help
help:
	@echo "'make clean' to destroy virtual machine(s)"
	@echo "'make check' to validate content"
	@echo "'make update' vagrant box update"
	@echo "'make single-host' to run playbook against web"
	@echo "'make across-hosts' to run playbook against db and web"
	@echo "'make test' validate result"


secrets.yml:
	@echo 'copy secrets.yml.example to secrets.yml and change the values'
	@exit 1

.PHONY: check
check: secrets.yml
	ansible-inventory --graph -i inventory
	ansible-playbook --syntax-check mezzanine-single-host.yml mezzanine-across-hosts.yml
	ansible-lint mezzanine-single-host.yml mezzanine-across-hosts.yml
	git ls-files *.yml | xargs yamllint
	vagrant validate

.PHONY: update
update:
	vagrant box update

.PHONY: db
db:
	vagrant up db --no-provision

.PHONY: web
web:
	vagrant up web --no-provision

.PHONY: across-hosts
across-hosts: db web check
	ansible-playbook -v mezzanine-across-hosts.yml

.PHONY: single-host
single-host: web check
	ansible-playbook -v mezzanine-single-host.yml

.PHONY: clean
clean:
	vagrant destroy -f
	@rm -rf .vagrant/
	ssh-keygen -R [127.0.0.1]:2222

.PHONY: test
test:
	@echo 'make test should display this line twice:'
	@echo '<h2>Congratulations!</h2>'
	@curl -s -k https://www.192.168.56.10.nip.io/ | grep h2

all: clean update single-host clean across-hosts test
