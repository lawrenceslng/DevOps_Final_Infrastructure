variable "ssh_public_key" {
  type        = string
  description = "The contents of the public SSH key to add to the AMI"
}

packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "QA_AMI_2"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-084568db4383264d4"
  ssh_username  = "ubuntu"
}

build {
  name = "qa-ec2-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "file" {
    source      = "../terraform/init.sql"
    destination = "/home/ubuntu/init.sql"
  }

  provisioner "shell" {
    inline = [
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh",

      "sudo service docker start",
      "sudo usermod -a -G docker ubuntu",

      "sudo mkdir -p /opt/init-sql",
      "sudo mv /home/ubuntu/init.sql /opt/init-sql/init-qa.sql",
      "sudo chown -R ubuntu:ubuntu /opt/init-sql",
      "ls -la /opt/init-sql",


      "mkdir -p /home/ubuntu/.ssh",
      "chmod 700 /home/ubuntu/.ssh",

      # Placeholder for SSH public key (will be replaced dynamically)
      "echo '${var.ssh_public_key}' | sudo tee -a /home/ubuntu/.ssh/authorized_keys",

      "chmod 600 /home/ubuntu/.ssh/authorized_keys",
      "chown -R ubuntu:ubuntu /home/ubuntu/.ssh"
    ]
  }
}
