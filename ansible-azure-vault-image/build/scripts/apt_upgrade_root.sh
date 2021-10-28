# !/bin/bash

# UPGRADE THE SYSTEM
 apt-get update
 apt-get upgrade -y

# INSTALL PREREQUISITES
 apt-get install --no-install-recommends -y software-properties-common wget curl git make python python-setuptools
