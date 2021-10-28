# !/bin/bash

# INSTALL ANSIBLE

# get python 2.x
apt-get update
apt-get install python-minimal -y

# packages you need
apt-get install software-properties-common python python-pip -y
apt-get install sshpass -y

# packages that you will want to have
apt-get install apt-transport-https ca-certificates -y
apt-get install python-dev libffi-dev libssl-dev -y

# prereq
pip install setuptools --upgrade
pip install pyopenssl ndg-httpsclient pyasn1

# install Ansible
pip install ansible
