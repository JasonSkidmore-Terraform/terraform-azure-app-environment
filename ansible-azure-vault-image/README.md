# ansible
Devops repo for creating artifacts for server/container builds
We have AMI cleanup script which will retain the most recent  x number of AMI's from group and delete the older ones.
    * Following groups will be defined ["vault","consul","rabbitmq","logstash-indexer","ec2-docker","mule","nomad","nomad-agent"] in lambda script which will group the images and process further.
    * For this script to work you need to pass flag release with value latest while generating image from packer.
    $ packer build -var release=latest build/server/consul.json

To build push docker images in ECR for DR region.
$ packer build -var repository_uri={your_repo} build/containers/fly.json


You will notice that `fewknow` is the domain and client specific place holder.  Feel free to replace with you domain or client info in a separate branch.
