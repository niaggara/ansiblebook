#!/usr/bin/env bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y python3-venv
sudo apt-get autoremove -y
python3 -m venv venv
# shellcheck disable=SC1091
source venv/bin/activate
pip3 install wheel
pip3 install mezzanine
mezzanine-project myproject
cd myproject || exit
sed -i 's/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = ["*"]/' myproject/settings.py
python manage.py migrate
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'P@ssw0rd!')" | python manage.py shell
python manage.py runserver 0.0.0.0:8000 &
