# !/bin/bash

# UPGRADE THE SYSTEM
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install python-pip -y
# INSTALL PREREQUISITES
sudo apt-get install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y software-properties-common wget curl git make python python-setuptools
