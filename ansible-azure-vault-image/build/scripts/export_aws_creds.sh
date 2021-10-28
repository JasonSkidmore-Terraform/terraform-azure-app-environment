# !/bin/bash

echo "make directory ~/.aws"
mkdir ~/.aws

echo "writing to file ~/.aws/config"
echo "[default]" >> ~/.aws/config
echo "aws_access_key_id=$KEY" >> ~/.aws/config
echo "aws_secret_access_key=$SECRET" >> ~/.aws/config


echo "check that file exists"
cat ~/.aws/config
