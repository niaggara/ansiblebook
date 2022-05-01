# Makefile for ansible execution environments using ansible-runner

BASE_NAME=ansible-controller
ANSIBLE_RUNNER_IMAGE=quay.io/ansible/ansible-runner:stable-2.9-devel

.PHONY standalone:
standalone:
	ansible-runner run playbooks -p playbook.yml

.PHONY python_interface:
python_interface:
	./play.py

.PHONY image:
image:
	docker build --build-arg ANSIBLE_RUNNER_IMAGE=${ANSIBLE_RUNNER_IMAGE} --tag ${BASE_NAME} context

.PHONY build:
build:
	ansible-builder build --build-arg ANSIBLE_RUNNER_IMAGE=${ANSIBLE_RUNNER_IMAGE} -t ${BASE_NAME} -c context --container-runtime docker

.PHONY run:
run:
	docker run --rm --network=host -ti -v${HOME}/.ssh:/root/.ssh -v ${PWD}/playbooks:/runner ${BASE_NAME} bash

.PHONY container:
container:
	docker run --rm --network=host -v ${PWD}/playbooks:/runner -e RUNNER_PLAYBOOK=playbook.yml ansible-controller

clean:
	rm -rf .venv context playbooks/artifacts/*
