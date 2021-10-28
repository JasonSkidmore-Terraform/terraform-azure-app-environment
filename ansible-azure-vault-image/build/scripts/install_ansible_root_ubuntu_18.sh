# !/bin/bash

# INSTALL ANSIBLE

apt-get update

apt-get install software-properties-common python -y
apt-get install sshpass -y

# packages that you will want to have
apt-get install apt-transport-https ca-certificates -y
apt-get install python-dev libffi-dev libssl-dev -y

# get python 2.x

apt-get install python-minimal -y

# packages you need
echo "unistall pip"
python -m pip uninstall pip  # this might need sudo
echo "re-install pip"
apt install --reinstall python-pip -y

# prereq
pip install setuptools --upgrade
pip install pyopenssl ndg-httpsclient pyasn1

# install Ansible
pip install ansible
