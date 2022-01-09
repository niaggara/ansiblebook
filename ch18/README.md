# Chapter 18 Vagrant

## local

This directory holds a simple example from the first edition of Ansible Up and Running.

## playbooks

This directory holds an advanced example from the third edition of Ansible Up and Running.

Using the Vagrantfile in this directory you can spin up various VirtualBox virtual machines using Vagrant:

```yaml
machines:
  - bionic
  - bullseye
  - buster
  - centos7
  - centos8
  - fedora
  - focal
  - hirsute
  - impish
  - jessie
  - kali
  - rocky
  - stretch
  - xenial
```

### Provisioning

`vagrant provision` is automated with the ansible `playbook.yml` which installs
the dependencies defined in `roles/requirements.yml`.

### Configuration

`config.json` holds the parameters for each machine.

### Inventory

There is a dynamic inventory in `inventory/vagrant.py`. The `vagrant-hostmaster`
manages `/etc/hosts` on the host and guests.
