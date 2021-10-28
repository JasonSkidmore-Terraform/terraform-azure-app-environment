# !/bin/bash

# ADD VAGRANT USER TO SUDOERS
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# INSTALL NECESSARY LIBRARIES FOR GUEST ADDITIONS AND VAGRANT NFS SHARE
sudo apt-get -y -q install linux-headers-$(uname -r) build-essential dkms nfs-common

# INSTALL NECESSARY DEPENDENCIES
sudo apt-get -y -q install curl wget git vim

# INSTALLING VAGRANT KEYS
mkdir ~/.ssh
chmod 700 ~/.ssh
cd ~/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 ~/.ssh/authorized_keys
chown -R vagrant ~/.ssh

VER="`cat /home/vagrant/.vbox_version`"
ISO="VBoxGuestAdditions_$VER.iso"
mkdir -p /tmp/vbox
mount -o loop $HOME_DIR/$ISO /tmp/vbox
sh /tmp/vbox/VBoxLinuxAdditions.run \
    || echo "VBoxLinuxAdditions.run exited $? and is suppressed." \
        "For more read https://www.virtualbox.org/ticket/12479"
umount /tmp/vbox
rm -rf /tmp/vbox
rm -f $HOME_DIR/*.iso
