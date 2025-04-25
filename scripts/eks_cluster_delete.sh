#!/bin/bash

# Load environment variables
source eks-args.env

# Ensure required env vars are loaded
if [[ -z "$EKS_CLUSTER_NAME" || -z "$AWS_REGION" ]]; then
  echo "❌ Missing EKS_CLUSTER_NAME or AWS_REGION in eks-args.env"
  exit 1
fi

echo "🔎 Preparing to delete EKS resources for cluster: $EKS_CLUSTER_NAME in region: $AWS_REGION"

# 1. Delete Node Groups
echo "🗑️ Deleting node groups..."

aws eks delete-nodegroup \
  --cluster-name "$EKS_CLUSTER_NAME" \
  --nodegroup-name "worker-group-1" \
  --region "$AWS_REGION"

aws eks delete-nodegroup \
  --cluster-name "$EKS_CLUSTER_NAME" \
  --nodegroup-name "worker-group-2" \
  --region "$AWS_REGION"

echo "⌛ Waiting for node groups to be deleted..."
# Wait until node groups are deleted
aws eks wait nodegroup-deleted --cluster-name "$EKS_CLUSTER_NAME" --nodegroup-name "worker-group-1" --region "$AWS_REGION" || true
aws eks wait nodegroup-deleted --cluster-name "$EKS_CLUSTER_NAME" --nodegroup-name "worker-group-2" --region "$AWS_REGION" || true

# 2. Delete EKS Cluster
echo "🗑️ Deleting EKS cluster..."

aws eks delete-cluster \
  --name "$EKS_CLUSTER_NAME" \
  --region "$AWS_REGION"

echo "⌛ Waiting for cluster to be deleted..."
aws eks wait cluster-deleted --name "$EKS_CLUSTER_NAME" --region "$AWS_REGION" || true

# 3. Optional: Delete Kubernetes namespaces locally (not needed once cluster is gone)
# (Skipped because if the cluster is deleted, namespaces are deleted too.)

echo "✅ EKS cluster and node groups deleted successfully."
