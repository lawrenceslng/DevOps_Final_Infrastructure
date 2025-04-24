#!/bin/bash

# This script generates environment variables from terraform output
# and formats them for use in EKS CLI scripts.

TF_OUTPUT_FILE="../terraform/tf-outputs.json"
ENV_VAR_FILE=".env_var"

# Ensure terraform output file exists
if [[ ! -f "$TF_OUTPUT_FILE" ]]; then
  echo "❌ Terraform output file $TF_OUTPUT_FILE not found. Run 'terraform output -json > $TF_OUTPUT_FILE' first."
  exit 1
fi

# Ensure terraform output file exists
if [[ ! -f "$ENV_VAR_FILE" ]]; then
  echo "❌ .env_var file not found. Create it based on .env_var.example and try again."
  exit 1
fi

# Load .env_var values
source "$ENV_VAR_FILE"

# Extract values
PRIVATE_SUBNETS=$(jq -r '.private_subnets.value | join(",")' "$TF_OUTPUT_FILE")
PUBLIC_SUBNETS=$(jq -r '.public_subnets.value | join(",")' "$TF_OUTPUT_FILE")
VPC_ID=$(jq -r '.vpc_id.value' "$TF_OUTPUT_FILE")
VPC_CIDR=$(jq -r '.vpc_cidr_block.value' "$TF_OUTPUT_FILE")
NAT_PUBLIC_IPS=$(jq -r '.nat_public_ips.value | join(",")' "$TF_OUTPUT_FILE")
AVAILABILITY_ZONES=$(jq -r '.azs.value | join(",")' "$TF_OUTPUT_FILE")
WORKER_GROUP_ONE_SG_ID=$(jq -r '.worker_group_mgmt_one_sg_id.value' "$TF_OUTPUT_FILE")
WORKER_GROUP_TWO_SG_ID=$(jq -r '.worker_group_mgmt_two_sg_id.value' "$TF_OUTPUT_FILE")
ALL_WORKER_SG_ID=$(jq -r '.all_worker_mgmt_sg_id.value' "$TF_OUTPUT_FILE")

# Write to file
cat > eks-args.env <<EOF
# Generated from terraform outputs and .env_var
EKS_CLUSTER_NAME="$EKS_CLUSTER_NAME"
AWS_REGION="$AWS_REGION"
AWS_ROLE="$AWS_ROLE"
PRIVATE_SUBNETS="$PRIVATE_SUBNETS"
PUBLIC_SUBNETS="$PUBLIC_SUBNETS"
VPC_ID="$VPC_ID"
VPC_CIDR="$VPC_CIDR"
NAT_PUBLIC_IPS="$NAT_PUBLIC_IPS"
AVAILABILITY_ZONES="$AVAILABILITY_ZONES"
WORKER_GROUP_ONE_SG_ID="$WORKER_GROUP_ONE_SG_ID"
WORKER_GROUP_TWO_SG_ID="$WORKER_GROUP_TWO_SG_ID"
ALL_WORKER_SG_ID="$ALL_WORKER_SG_ID"
EOF

echo "✅ EKS configuration written to eks-args.env"