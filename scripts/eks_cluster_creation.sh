#!/bin/bash

source eks-args.env

aws eks create-cluster --name "test-cluster" --region "us-east-1" --role-arn $AWS_ROLE --resources-vpc-config subnetIds=$PRIVATE_SUBNETS,securityGroupIds=sg-abc

aws eks create-nodegroup \
  --cluster-name "test-cluster" \
  --nodegroup-name "worker-group-1" \
  --scaling-config minSize=1,maxSize=3,desiredSize=2 \
  --disk-size 20 \
  --subnets $PRIVATE_SUBNETS \  # need to change to format subnet-abc subnet-def subnet-xyz 
  --instance-types t2.small \
  --ami-type AL2_x86_64 \
  --node-role $AWS_ROLE \
  --region "us-east-1"

aws eks create-nodegroup \
  --cluster-name "test-cluster" \
  --nodegroup-name "worker-group-2" \
  --scaling-config minSize=1,maxSize=3,desiredSize=2 \
  --disk-size 20 \
  --subnets $PRIVATE_SUBNETS \  # need to change to format subnet-abc subnet-def subnet-xyz 
  --instance-types t2.medium \
  --ami-type AL2_x86_64 \
  --node-role $AWS_ROLE \
  --region "us-east-1"

# 3. Update kubeconfig for kubectl access
aws eks update-kubeconfig --region "us-east-1" --name "test-cluster"

# 4. replace below with kubectl apply ?
kubectl create namespace uat || echo "Namespace 'uat' already exists"
kubectl create namespace prod || echo "Namespace 'prod' already exists"

