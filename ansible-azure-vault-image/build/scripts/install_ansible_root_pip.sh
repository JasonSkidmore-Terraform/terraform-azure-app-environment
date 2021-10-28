# !/bin/bash


yum -y install gcc libffi-devel python-devel openssl-devel git

pip install --upgrade pip

/usr/local/bin/pip install -U setuptools

/usr/local/bin/pip install git+git://github.com/ansible/ansible.git@devel