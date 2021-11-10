#!/usr/bin/python
# -*- coding: utf-8 -*-
""" her_module ansible module """
from ansible.module_utils.basic import AnsibleModule

DOCUMENTATION = r'''
---
module: her_module
short_description: Checks server reachability
description: Checks if a remote server can be reached

options:
  host:
    description:
      - A DNS hostname or IP address
    required: true
  port:
    description:
      - The TCP port number
      required: true
  timeout:
    description:
      - The amount of time trying to connect before giving up, in seconds
    required: false
    default: 3

requirements: [nmap]
author: Lorin Hochstein, Bas Meijer
notes:
  - This is just an example to demonstrate how to write a module.
  - You probably want to use the native M(wait_for) module instead.
'''

EXAMPLES = r'''
# Check that ssh is running, with the default timeout
- her_module: host=localhost port=22 timeout=1

# Check if postgres is running, with a timeout
- her_module: host=example.com port=5432
'''


def her_module(module, host, port, timeout):
    """ her_module is a method that does a tcp connect with nc """
    nc_path = module.get_bin_path('nc', required=True)
    args = [nc_path, "-z", "-v", "-w", str(timeout), host, str(port)]
    # (return_code, stdout, stderr) = module.run_command(args)
    return module.run_command(args, check_rc=True)


def main():
    """ ansible module that uses netcat to connect """
    module = AnsibleModule(
        argument_spec=dict(
            host=dict(required=True),
            port=dict(required=True, type='int'),
            timeout=dict(required=False, type='int', default=3)
        ),
        supports_check_mode=True
    )

    # In check mode, we take no action
    # Since this module never changes system state, we just
    # return changed=False
    if module.check_mode:
        module.exit_json(changed=False)
    host = module.params['host']
    port = module.params['port']
    timeout = module.params['timeout']

    if her_module(module, host, port, timeout)[0] == 0:
        msg = "Could reach %s:%s" % (host, port)
        module.exit_json(changed=False, msg=msg)
    else:
        msg = "Could not reach %s:%s" % (host, port)
        module.fail_json(failed=True, msg=msg)


if __name__ == "__main__":
    main()
