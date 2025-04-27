# DevOps_Final_Infrastructure

Repo Settings → Actions → General → Workflow permissions

    ✔️ Select: "Read and write permissions"

    Click Save

## Prereq

download PEM file
move PEM file into Infra directory
chmod 600 <PEM FILE PATH>
ssh-add <PEM FILE PATH> 

1. do `chmod +x` for all scripts 
2. run `/scripts/setup_env.sh`
3. `cd` into scripts and run `./packer_build.sh`
4. find the created AMI in AWS Console, copy the AMI ID
5. copy it into `terraform/variables.tf`
6. `cd` into `/scripts` and run `run_terraform.sh`, enter `yes` when prompted 
7. run `./generate-eks-args.sh`
8. Create the EKS cluster and node groups by running `Infra/scripts/eks_cluster_creation.sh` and replacing with correct variables

need to add inbound outbound http traffic for ALB for QA

in QA EC2

install aws cli (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
configure aws credential
aws ecr get-login-password --region us-east-1 \
  | docker login --username AWS \
  --password-stdin 677005902461.dkr.ecr.us-east-1.amazonaws.com
docker compose up

## on every Lab Start

1. run `/scripts/setup_env.sh`
2. change the following Github secrets
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN
and after terraform, the following:
- AWS_PRIVATE_SUBNET_ID
- AWS_PUBLIC_SUBNET_ID
- AWS_QA_SECURITY_GROUP_ID
- AWS_VPC_ID

follow 03 to 06 scripts, use `retag-image-test.sh` to promote images to RC-1 and GA-1

Create ALB and target group to private ec2 manually

sg-035a44499abd77d26 - eks-cluster-sg-eks-cluster-365256518 needs inbound rule from 0.0.0.0/0 


## Flow

1. live website it up and running
2. change is made to frontend code and pushed
3. 

# NOTES 4/26

## on every Lab Start

1. run `/scripts/setup_env.sh`
2. download .pem file and place in Infra 

### base 64 key to Github secrets

3. do `base64 -i labsuser.pem` and copy paste to Github secrets

### Secrets that need updating every start
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
SSH_PRIVATE_KEY

currently:
- able to do nightly build
- able to launch QA
- able to manually destroy QA

to do:
- at end of QA, we need to 
    - tag the image `nightly-latest` with `rc-1` if that image does not have any `rc-*` or `ga-*` already
    - create a branch and PR in the appropriate repo that
        - has VERSION updated to include `-rc-1` at end
    - wait for merge, on push to main, the github actions `Destroy_QA.yaml` and `Deploy_to_UAT.yaml` should run

- need to change `Deploy_to_UAT.yaml` to create the ALB dynamically like done in `Deploy_to_QA.yaml`



### Promotion flow

1. Nightly builds happen → Images: nightly-20250426 + nightly-latest
2. QA tests nightly-latest
3. QA clicks "Approve" button (simulated by `promote-to-uat.sh` shell script) → updates VERSION to -rc-1
4. GitHub Action sees VERSION pushed → triggers Infra repository_dispatch
5. Infra GitHub Action:
   a. Reads service + new version
   b. Re-tags ECR nightly-latest → {new-version}
   c. Pushes new tag to ECR
   d. Deploys RC-1 image to UAT servers
   e. Updates Infra/services.json
