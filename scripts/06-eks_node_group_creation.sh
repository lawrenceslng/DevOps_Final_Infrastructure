#!/bin/bash

source eks-args.env

aws eks create-nodegroup \
  --cluster-name $EKS_CLUSTER_NAME \
  --nodegroup-name "worker-group-1" \
  --scaling-config minSize=1,maxSize=3,desiredSize=2 \
  --disk-size 20 \
  --subnets $PRIVATE_SUBNETS_SPACE_SEPARATED \
  --instance-types "t2.small" \
  --ami-type "AL2_x86_64" \
  --node-role $AWS_ROLE \
  --region $AWS_REGION

aws eks create-nodegroup \
  --cluster-name $EKS_CLUSTER_NAME \
  --nodegroup-name "worker-group-2" \
  --scaling-config minSize=1,maxSize=3,desiredSize=2 \
  --disk-size 20 \
  --subnets $PRIVATE_SUBNETS_SPACE_SEPARATED \ 
  --instance-types "t2.medium" \
  --ami-type "AL2_x86_64" \
  --node-role $AWS_ROLE \
  --region $AWS_REGION
