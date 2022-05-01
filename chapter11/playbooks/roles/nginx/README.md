install-nginx
=========

Secure your web service with TLS. This ansible role installs Nginx with strict
security for modern browsers.

Requirements
------------

This Ansible role is designed for Centos 7 Servers.


Role Variables
--------------
- `nginx_https_transport: false` Set it to true to enable encryption.
- `nginx_dhparam_key_size: 2048` Defines the KeyExchange strength.

- `nginx_https_transport: true` will start serving all traffic with HTTP Strict Transport Security. There is no way back until the max-age expires!

`hsts_max_age:` It is recommended to force https for at least 120 days, please note that this information is stored in the browser. The dev default is 120 seconds, set to 10368001 recommended production setting.

As a reverse-proxy, Nginx will offload SSL for an app that you need to configure with 2 vars:
1. app_context: /my_app
2. app_url: http://localhost:8080

Dependencies
------------
-


Example Playbook
----------------

    - hosts: webservers
      roles:
         - { role: nginx }

License
-------

MIT

Author Information
------------------
Bas Meijer
