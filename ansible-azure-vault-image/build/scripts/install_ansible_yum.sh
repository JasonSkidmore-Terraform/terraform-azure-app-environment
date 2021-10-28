#!/bin/bash

echo "Enable EPEL"
sudo yum -y install epel-release

echo "INSTALL ANSIBLE"
sudo yum -y install ansible