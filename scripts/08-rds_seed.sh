#!/bin/bash

# source eks-args.env

# ====== CONFIGURE THESE ======
AWS_REGION="us-east-1"
AMI_ID="ami-0e449"            # <-- Update this (use Amazon Linux 2 AMI or similar)
INSTANCE_TYPE="t2.micro"
KEY_PAIR_NAME=""                    # <-- Key pair you have in AWS
SECURITY_GROUP_ID="sg-0ff"  # <-- Security group allowing SSH
SUBNET_ID="subnet-0f3d"      # <-- Private or public subnet
USER_SCRIPT="seed_db.sh"                  # <-- Your script to run remotely
# ==============================

# Step 1: Launch EC2 instance
echo "Launching EC2 instance..."
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_PAIR_NAME \
  --security-group-ids $SECURITY_GROUP_ID \
  --subnet-id $SUBNET_ID \
  --associate-public-ip-address \
  --region $AWS_REGION \
  --query "Instances[0].InstanceId" \
  --output text)

echo "Instance ID: $INSTANCE_ID"

# Step 2: Wait for instance to be running
echo "Waiting for EC2 to be in 'running' state..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region $AWS_REGION

# Step 3: Get the public IP address
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --region $AWS_REGION \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

echo "Public IP: $PUBLIC_IP"

# Step 4: Wait a little for SSH readiness
echo "Waiting 30 seconds for SSH to be ready..."
sleep 30

# Step 5: Copy your script to the instance
echo "Copying script to EC2..."
scp -i ../labsuser.pem -o StrictHostKeyChecking=no $USER_SCRIPT ec2-user@$PUBLIC_IP:/home/ec2-user/

# Step 6: SSH into instance and run the script
echo "Running the script on EC2..."
ssh -i ../labsuser.pem -o StrictHostKeyChecking=no ec2-user@$PUBLIC_IP "chmod +x /home/ec2-user/$USER_SCRIPT && /home/ec2-user/$USER_SCRIPT"

# (Optional) Step 7: Terminate instance after work is done
echo "Terminating EC2 instance..."
aws ec2 terminate-instances --instance-ids $INSTANCE_ID --region $AWS_REGION

echo "Done!"
