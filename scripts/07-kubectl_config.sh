#!/bin/bash

source eks-args.env

# 3. Update kubeconfig for kubectl access
aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER_NAME

# 4. replace below with kubectl apply ?
# kubectl create namespace uat || echo "Namespace 'uat' already exists"
# kubectl create namespace prod || echo "Namespace 'prod' already exists"