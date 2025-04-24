#!/bin/bash

chmod 600 ../labsuser.pem

packer init ../terraform
packer fmt ../terraform

AMI_ID=$(packer build \
  -var "ssh_public_key=$(ssh-keygen -y -f ../labsuser.pem)" \
  ../terraform/packer.pkr.hcl | tee /dev/tty | grep -o 'ami-[a-zA-Z0-9]*' | tail -1)

# Consider echo'ing AMI_ID out to a file for automation