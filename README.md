# DevOps_Final_Infrastructure

1. do `chmod +x` for all scripts 
2. run `/scripts/setup_env.sh`
3. `cd` into scripts and run `./packer_build.sh`
4. find the created AMI in AWS Console, copy the AMI ID
5. copy it into `terraform/variables.tf`
6. `cd` into `/scripts` and run `run_terraform.sh`, enter `yes` when prompted 
7. run `./generate-eks-args.sh`
8. Create the EKS cluster and node groups by running `Infra/scripts/eks_cluster_creation.sh` and replacing with correct variables