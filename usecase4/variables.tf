variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Linux 2 or Ubuntu AMI with Docker support"
}

variable "key_name" {
  description = "Key pair name for EC2 SSH access"
}