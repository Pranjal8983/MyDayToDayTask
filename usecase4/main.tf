module "ec2_devlock" {
  source     = "./modules/ec2-devlock"
  aws_region = var.aws_region
  ami_id     = var.ami_id
  key_name   = var.key_name
}

output "alb_dns" {
  value = module.ec2_devlock.alb_dns
}

