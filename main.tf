module "vpc" {

  source = "./modules/vpc"

  project_name = var.project_name

  vpc_cidr = "10.0.0.0/16"

  public_subnets = [

    "10.0.1.0/24",

    "10.0.2.0/24"

  ]

  private_app_subnets = [

    "10.0.3.0/24",

    "10.0.4.0/24"

  ]

  private_db_subnets = [

    "10.0.5.0/24",

    "10.0.6.0/24"

  ]

  availability_zones = [

    "eu-north-1a",

    "eu-north-1b"

  ]

}

module "security_groups" {

  source = "./modules/security_groups"

  project_name = var.project_name

  vpc_id = module.vpc.vpc_id

  my_ip = var.my_ip

}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "alb" {
  source         = "./modules/alb"
  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  alb_sg         = module.security_groups.alb_sg_id
}

module "ec2" {
  source           = "./modules/ec2"
  project_name     = var.project_name
  ec2_sg           = module.security_groups.ec2_sg_id
  private_subnets  = module.vpc.private_app_subnet_ids
  instance_profile = module.iam.instance_profile
  target_group     = module.alb.target_group_arn
}

module "rds" {

  source = "./modules/rds"

  project_name = var.project_name

  private_db_subnets = module.vpc.private_db_subnet_ids

  rds_sg = module.security_groups.rds_sg_id

  db_username = var.db_username

  db_password = var.db_password

}

module "s3" {

  source = "./modules/s3"

  project_name = var.project_name

}