echo "apt-get commands"
sudo apt-get update -y && sudo apt-get install -y ruby unzip

echo "wget for ec2 ami tools"
wget https://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.zip

echo "make directory"
sudo mkdir -p /usr/local/ec2

echo "unzip tools"
sudo unzip ec2-ami-tools.zip -d /usr/local/ec2

echo "Create /etc/profile.d/myenvvars.sh"
sudo touch /etc/profile.d/myenvvars.sh

echo "Installing kpartx, grub as required by ec2-ami-tools"
sudo apt-get install kpartx -y
sudo apt-get install grub -y

echo "add to etc/profile.d/myenvvars.sh export variable EC2_AMITOOL_HOME"
sudo bash -c 'echo "export EC2_AMITOOL_HOME=/usr/local/ec2/ec2-ami-tools-1.5.7" >> /etc/profile.d/myenvvars.sh'
sudo bash -c 'echo "export PATH=/usr/local/ec2/ec2-ami-tools-1.5.7/bin:$PATH:" >> /etc/profile.d/myenvvars.sh'
