# !/bin/bash


sudo yum -y install gcc libffi-devel python-devel openssl-devel git

sudo pip install --upgrade pip

sudo /usr/local/bin/pip install -U setuptools

sudo /usr/local/bin/pip install git+git://github.com/ansible/ansible.git@devel