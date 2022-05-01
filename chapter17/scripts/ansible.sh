#!/bin/bash -eux
major=$(tr -dc '0-9.' < /etc/redhat-release|cut -d \. -f1)
if ((major < 8))
then
  # Install EPEL repository.
  yum -y --enablerepo=extras install epel-release
  yum install -y python-pip python-devel
  yum -y install python-jmespath || pip install jmespath

  # Install Ansible.
  yum -y install ansible ansible-doc ansible-lint python-setuptools
else
  dnf makecache
  dnf install -y epel-release
  dnf makecache
  dnf install -y ansible
fi
