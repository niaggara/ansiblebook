# type 'make' for help with this Makefile

.PHONY: help
help:
	@echo "'make clean' to destroy virtual machine(s)"
	@echo "'make check' to validate content"
	@echo "'make update' vagrant box update"
	@echo "'make deploy' to run playbook against db and web"
	@echo "'make test' validate result"


secrets.yml:
	@echo 'copy secrets.yml.example to secrets.yml and change the values'
	@exit 1

.PHONY: check
check: secrets.yml
	ansible-inventory --graph -i inventory
	ansible-playbook --syntax-check playbook.yml
	ansible-lint playbook.yml
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

.PHONY: deploy
deploy: db web check
	ssh-keygen -R 192.168.56.10
	ssh-keygen -R 192.168.56.11
	ssh-keyscan 192.168.56.10 >> ~/.ssh/known_hosts
	ssh-keyscan 192.168.56.11 >> ~/.ssh/known_hosts
	vagrant provision

.PHONY: clean
clean:
	vagrant destroy -f
	@rm -rf .vagrant/

.PHONY: test
test:
	@echo 'make test should display this line twice:'
	@echo '<h2>Congratulations!</h2>'
	@curl -s -k https://www.192.168.56.10.nip.io/ | grep h2

all: clean update single-host clean across-hosts test
