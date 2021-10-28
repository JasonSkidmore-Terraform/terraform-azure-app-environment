# !/bin/bash

########### LEAVE COMMENTED OUT #############
# # INSTALL ANSIBLE
#
# sudo apt-get update
#
# # packages that you will want to have
# sudo apt-get install python3-pip sshpass apt-transport-https ca-certificates -y
#
# sudo ln -s /usr/bin/python3 /usr/bin/python
# sudo ln -s /usr/bin/pip3 /usr/bin/pip
#
# # prereq
# pip install setuptools --upgrade
# pip install pyopenssl ndg-httpsclient pyasn1
#
# # install Ansible
# sudo pip install ansible


# INSTALL ANSIBLE

sudo apt-get update

sudo apt-get install software-properties-common python -y
sudo apt-get install sshpass -y

# packages that you will want to have
sudo apt-get install apt-transport-https ca-certificates -y
sudo apt-get install python-dev libffi-dev libssl-dev -y

# get python 2.x

sudo apt-get install python-minimal -y

# packages you need
echo "unistall pip"
sudo python -m pip uninstall pip  # this might need sudo
echo "re-install pip"
sudo apt install --reinstall python-pip -y

# prereq
sudo pip install setuptools --upgrade
sudo pip install pyopenssl ndg-httpsclient pyasn1

# install Ansible
sudo pip install ansible
