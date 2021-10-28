# !/bin/bash

# INSTALL ANSIBLE

# get python 2.x
sudo apt-get update
sudo apt-get install python-minimal -y

# packages you need
sudo apt-get install software-properties-common python python-pip -y
sudo apt-get install sshpass -y

# packages that you will want to have
sudo apt-get install apt-transport-https ca-certificates -y
sudo apt-get install python-dev libffi-dev libssl-dev -y

# prereq
sudo pip install pip --upgrade
sudo pip install setuptools --upgrade
sudo pip install pyopenssl ndg-httpsclient pyasn1

# install Ansible
sudo pip install ansible
