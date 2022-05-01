# type 'make' for help with this Makefile

.PHONY: help
help:
	@echo "'make install' to install libraries"
	@echo "'make check' to validate content"
	@echo "'make no-tls' to run first playbook"
	@echo "'make tls' to run second playbook"
	@echo "'make test' to run test webserver"


.PHONY: install
install:
	pip3 install --user -r requirements.txt
	pipx install --force jinjalint

.PHONY: check
check:
	ansible-inventory --graph
	ansible-inventory --host testserver -i inventory/vagrant.ini
	ansible-playbook --syntax-check webservers-tls.yml
	ansible-lint webservers-tls.yml
	vagrant validate
	git ls-files *.yml | xargs yamllint

update:
	vagrant box update

up:
	vagrant up --no-provision

.PHONY: no-tls
no-tls: up
	ansible-playbook webservers2.yml

.PHONY: tls
tls: no-tls
	@mkdir -p files
	openssl req -x509 -nodes -newkey rsa:2048 \
		-subj /CN=localhost \
		-keyout files/nginx.key \
		-out files/nginx.crt
	ansible-playbook webservers-tls.yml

.PHONY: test
test:
	curl --fail --head http://localhost:8080/index.html
	curl --fail --head -k https://localhost:8443/index.html
	ansible-playbook webservers-tls.yml --tags test -vv

.PHONY: clean
clean:
	rm -f files/nginx.key files/nginx.crt
	vagrant destroy -f

all: clean tls test clean
