#!/bin/bash

# Adding epel repo
sudo yum-config-manager --enable epel

# Base packages
PACKAGES="
git
initscripts
jq
net-tools
python-pip
"

# Looping the through and install the PACKAGES list
for fn in $PACKAGES; do
  sudo yum -y install $fn
done

# Installing Ansible -- this will be removed in the cleanup script
sudo pip install ansible
