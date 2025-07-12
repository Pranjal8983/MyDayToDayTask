provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
}

module "alb" {
  source           = "./modules/alb"
  vpc_id           = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "ec2" {
  source            = "./modules/ec2"
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.alb.ec2_sg_id
  target_group_arn  = module.alb.target_group_arn
