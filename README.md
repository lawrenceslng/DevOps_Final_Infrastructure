# DevOps_Final_Infrastructure

## Prereq

download PEM file
chmod 600 <PEM FILE>

1. do `chmod +x` for all scripts 
2. run `/scripts/setup_env.sh`
3. `cd` into scripts and run `./packer_build.sh`
4. find the created AMI in AWS Console, copy the AMI ID
5. copy it into `terraform/variables.tf`
6. `cd` into `/scripts` and run `run_terraform.sh`, enter `yes` when prompted 
7. run `./generate-eks-args.sh`
8. Create the EKS cluster and node groups by running `Infra/scripts/eks_cluster_creation.sh` and replacing with correct variables

in QA EC2

aws ecr get-login-password --region us-east-1 \
  | docker login --username AWS \
  --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com
docker compose up