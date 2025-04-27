#!/bin/bash

source eks-args.env

aws eks create-cluster --name $EKS_CLUSTER_NAME --region $AWS_REGION --role-arn $AWS_ROLE --resources-vpc-config subnetIds=$PRIVATE_SUBNETS,securityGroupIds=$ALL_WORKER_SG_ID,$WORKER_GROUP_ONE_SG_ID,$WORKER_GROUP_TWO_SG_ID


