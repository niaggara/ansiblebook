For the scripts in this directory, we use Vagrant's Ansible support to do all of
the provisioning, so you just need to do:

    cd playbooks
    vagrant up

The Makefile has scenarios, checks and a test. `make all` will do a full test-cycle. Type `make help` for help.
