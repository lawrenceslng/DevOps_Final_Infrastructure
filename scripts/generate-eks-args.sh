#!/bin/bash

# This script generates environment variables from terraform output
# and formats them for use in EKS CLI scripts.

OUTPUT_FILE="tf-outputs.json"

# Ensure terraform output file exists
if [[ ! -f "$OUTPUT_FILE" ]]; then
  echo "❌ Terraform output file $OUTPUT_FILE not found. Run 'terraform output -json > $OUTPUT_FILE' first."
  exit 1
fi

# Extract values
PRIVATE_SUBNETS=$(jq -r '.private_subnets.value | join(",")' "$OUTPUT_FILE")
PUBLIC_SUBNETS=$(jq -r '.public_subnets.value | join(",")' "$OUTPUT_FILE")
VPC_ID=$(jq -r '.vpc_id.value' "$OUTPUT_FILE")
VPC_CIDR=$(jq -r '.vpc_cidr_block.value' "$OUTPUT_FILE")
NAT_PUBLIC_IPS=$(jq -r '.nat_public_ips.value | join(",")' "$OUTPUT_FILE")
AVAILABILITY_ZONES=$(jq -r '.azs.value | join(",")' "$OUTPUT_FILE")

# Write to file
cat > eks-args.env <<EOF
# Generated from terraform outputs
PRIVATE_SUBNETS="$PRIVATE_SUBNETS"
PUBLIC_SUBNETS="$PUBLIC_SUBNETS"
VPC_ID="$VPC_ID"
VPC_CIDR="$VPC_CIDR"
NAT_PUBLIC_IPS="$NAT_PUBLIC_IPS"
AVAILABILITY_ZONES="$AVAILABILITY_ZONES"
EOF

echo "✅ EKS configuration written to eks-args.env"