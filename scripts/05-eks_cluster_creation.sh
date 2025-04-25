#!/bin/bash

source eks-args.env

aws eks create-cluster --name $EKS_CLUSTER_NAME --region $AWS_REGION --role-arn $AWS_ROLE --resources-vpc-config subnetIds=$PRIVATE_SUBNETS,securityGroupIds=$ALL_WORKER_SG_ID,$WORKER_GROUP_ONE_SG_ID,$WORKER_GROUP_TWO_SG_ID

aws eks create-nodegroup \
  --cluster-name $EKS_CLUSTER_NAME \
  --nodegroup-name "worker-group-1" \
  --scaling-config minSize=1,maxSize=3,desiredSize=2 \
  --disk-size 20 \
  --subnets $PRIVATE_SUBNETS_SPACE_SEPARATED \  # need to change to format subnet-abc subnet-def subnet-xyz 
  --instance-types t2.small \
  --ami-type AL2_x86_64 \
  --node-role $AWS_ROLE \
  --region $AWS_REGION

aws eks create-nodegroup \
  --cluster-name $EKS_CLUSTER_NAME \
  --nodegroup-name "worker-group-2" \
  --scaling-config minSize=1,maxSize=3,desiredSize=2 \
  --disk-size 20 \
  --subnets $PRIVATE_SUBNETS_SPACE_SEPARATED \  # need to change to format subnet-abc subnet-def subnet-xyz 
  --instance-types t2.medium \
  --ami-type AL2_x86_64 \
  --node-role $AWS_ROLE \
  --region $AWS_REGION

# 3. Update kubeconfig for kubectl access
aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER_NAME

# 4. replace below with kubectl apply ?
# kubectl create namespace uat || echo "Namespace 'uat' already exists"
# kubectl create namespace prod || echo "Namespace 'prod' already exists"

