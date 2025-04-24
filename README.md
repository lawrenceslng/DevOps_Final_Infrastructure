# DevOps_Final_Infrastructure

1. do `chmod +x` for all scripts 
2. run `/scripts/setup_env.sh`
3. `cd` into scripts and run `./packer_build.sh`
4. find the created AMI in AWS Console, copy the AMI ID
5. copy it into `terraform/variables.tf`
6. `cd` into terraform and do 
```
terraform init
terraform fmt
terraform validate
terraform apply
terraform output -json > tf-outputs.json

```
7. Create the EKS cluster and node groups by running `Infra/scripts/eks_cluster_creation.sh` and replacing with correct variables