echo 'deb http://http.debian.net/debian jessie-backports main' > /etc/apt/sources.list.d/backports.list
apt-get update -y
apt-get -t jessie-backports install "ansible" -y 
