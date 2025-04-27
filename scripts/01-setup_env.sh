#!/bin/bash

# Function to check if a command exists
check_command() {
    command -v "$1" >/dev/null 2>&1 || { echo >&2 "$1 is required but not installed. Exiting."; exit 1; }
}

# Check if Packer is installed
check_command packer

# Check if Terraform is installed
check_command terraform

# Check if helm is installed
check_command helm

# Check if AWS CLI is installed
check_command aws

# Check if eksctl is installed
check_command eksctl

# Get the current public IP address
PUBLIC_IP=$(curl -4 ifconfig.me)/32

# Prompt user for AWS credentials
read -p "Enter your AWS Access Key: " AWS_ACCESS_KEY
read -p "Enter your AWS Secret Access Key: " AWS_SECRET_KEY
read -p "Enter your AWS Session Token: " AWS_SESSION_TOKEN
read -p "Enter your AWS Region: " AWS_REGION

# Configure AWS CLI with the provided credentials
aws configure set aws_access_key_id "$AWS_ACCESS_KEY"
aws configure set aws_secret_access_key "$AWS_SECRET_KEY"
aws configure set aws_session_token "$AWS_SESSION_TOKEN"
aws configure set region "$AWS_REGION"

echo $PUBLIC_IP