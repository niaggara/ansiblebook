# Makefile for CI?CD
all: machine collections roles nexus jenkins git sonar demo

.PHONY: all clean collections roles
clean:
	vagrant destroy -f
	rm -rf .vagrant

collections:
	ansible-galaxy collection install -r roles/requirements.yml

roles:
	ansible-galaxy install --force -p roles -r roles/requirements.yml

machine:
	vagrant box update

nexus:
	vagrant up --no-provision server04
	./playbook.yml -l nexus

jenkins:
	vagrant up --no-provision server05
	./playbook.yml -l jenkins

git:
	vagrant up --no-provision server06
	./playbook.yml -l git

sonar:
	vagrant up --no-provision server07
	./playbook.yml -l sonar

demo:
	./open.sh

