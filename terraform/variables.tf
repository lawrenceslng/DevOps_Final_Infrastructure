variable "domain_name" {
  description = "Root domain for your site"
  default     = "codingwithboba.com"
}

variable "project_name" {
  default = "DevOps Final Project"
}

variable "region" {
  default = "us-east-1"
}

variable "profile" {
  default = "default"
}

variable "qa_ami_id" {
  type        = string
  default     = "ami-067de7d4a91b4848f" # INSERT QA AMI ID HERE
  description = "Put Your QA AMI Here"
}

variable "private_ssh_key" {
  type        = string
  default     = "vockey" # INSERT Private EC2 SSH KEY PAIR NAME HERE
  description = "Put Your Private EC2 SSH Key Here"
}

