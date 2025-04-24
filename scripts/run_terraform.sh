#!/bin/bash

echo $(pwd)

cd ../terraform

# terraform init
# terraform fmt
terraform validate
terraform apply
terraform output -json > tf-outputs.json