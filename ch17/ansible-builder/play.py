#!/usr/bin/env python3

import ansible_runner
r = ansible_runner.run(private_data_dir='./playbooks', playbook='playbook.yml')

print("{}: {}".format(r.status, r.rc))
print("Final status:")
prinr(r.stats)
