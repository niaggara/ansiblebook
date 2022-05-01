# source this file to run ansible out of checkout
python3 -m venv .venv --prompt S
source .venv/bin/activate
python3 -m pip install --upgrade pip
pip3 install wheel
git clone https://github.com/ansible/ansible.git --recursive
pip3 install -r ansible/requirements.txt
cd ./ansible
source ./hacking/env-setup
