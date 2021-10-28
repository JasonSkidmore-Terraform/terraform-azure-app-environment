apt-get install libxml-xpath-perl -y

apt-get install build-essential -y
wget http://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz
tar xf bash-4.4.tar.gz
cd bash-4.4
./configure
make
make install
cd ..
