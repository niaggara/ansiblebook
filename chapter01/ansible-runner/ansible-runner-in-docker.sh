#!/bin/bash
ANSIBLE_RUNNER_IMAGE=quay.io/ansible/ansible-runner:stable-2.9-devel
docker run --rm --network=host -ti -v${HOME}/.ssh:/root/.ssh -v ${PWD}/ansible:/runner ${ANSIBLE_RUNNER_IMAGE} bash
