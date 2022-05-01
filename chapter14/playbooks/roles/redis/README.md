base_redis
=============

Ansible-role to install Redis5 Sentinel on Centos/RHEL 7 (using Satellite).

Requirements
------------

Yum with Software Collections, this role has been developed for on-prem use.

Role Variables
--------------

See defaults/main.yml

Dependencies
------------

In your inventory define hosts like:

```
[redis_master]
node0.example.com

[redis_slave]
node1.example.com
node2.example.com

[redis_sentinel]
node0.example.com
node1.example.com
node2.example.com

```
Example Playbook
----------------

```
---
# Install Redis Sentinel on 3 RHEL7 VMs

- name: Discover Redis master
  hosts: redis_server
  become: true
  roles:
    - {role: base_redis, tags: master, slave}

- name: Install Redis master
  hosts: redis_leader
  become: true
  vars:
    redis_server: true
  roles:
    - {role: base_redis, tags: master}

- name: Install Redis slaves
  hosts: redis_server
  become: true
  vars:
    redis_server: true
  roles:
    - {role: base_redis, tags: slave}

- name: Configure Redis sentinel nodes
  hosts: redis_sentinel
  become: true
  vars:
    redis_sentinel: true
    redis_sentinel_monitors:
      - name: mymaster
        # host: "{{ groups.redis_master[0] }}"
        host: "{{ master_hostname }}"
        port: "{{ redis_host }}"
        quorum: "{{ groups.redis_server|length -1 }}"
  roles:
    - {role: base_redis, tags: sentinel}
```


License
-------

MIT

Author Information
------------------
@bbaassssiiee
