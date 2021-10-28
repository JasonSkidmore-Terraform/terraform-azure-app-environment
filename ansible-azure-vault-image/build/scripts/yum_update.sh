#!/bin/bash

sudo yum -y update

# INSTALL EPEL
sudo yum -y install wget
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
