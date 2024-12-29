provider "aws" {
  region     = "ap-south-1"
 

}
module "network" {
  source                 = "./network"
  vpc_cidr_block         = var.vpc_cidr_block
  public_subnet_1_cidr   = var.public_subnet_1_cidr
  public_subnet_2_cidr   = var.public_subnet_2_cidr
  private_subnet_1_cidr  = var.private_subnet_1_cidr
  private_subnet_2_cidr  = var.private_subnet_2_cidr
  public_subnet_1_az     = var.public_subnet_1_az
  public_subnet_2_az     = var.public_subnet_2_az
  private_subnet_1_az    = var.private_subnet_1_az
  private_subnet_2_az    = var.private_subnet_2_az
  destination_cidr_block = var.destination_cidr_block
  

}

module "security" {
    source = "./security"
    vpc_id = module.network.vpc_id
    vpc_cidr_block         = var.vpc_cidr_block

  
}

module "compute" {
    source = "./compute"
    security_group_id = module.security.security_group_id
    private_subnet_1_id = module.network.private_subnet_1_id
    private_subnet_1_az    = var.private_subnet_1_az
    public_subnet_1_id = module.network.public_subnet_1_id
    public_subnet_1_az_id = var.public_subnet_1_az
    key_name = "paritosh"
    

}

module "loadbalancer" {
  source = "./loadbalancer"
  my_instance_id = module.compute.my_instance_id
  vpc_id = module.network.vpc_id
  security_group_id = module.security.security_group_id
  public_subnet_1_id = module.network.public_subnet_1_id
  public_subnet_2_id = module.network.public_subnet_2_id
  
}

module "AMI" {
  source = "./AMI"
  my_instance_id = module.compute.my_instance_id

  
}

module "ASG" {
  source = "./ASG"
  demo_ami_id = module.AMI.demo_ami_id
  security_group_id = module.security.security_group_id
  demo_target_id = module.loadbalancer.demo_target_id
  # public_subnet_1_id = module.network.public_subnet_1_id
  # public_subnet_2_id = module.network.public_subnet_2_id
  private_subnet_1_id = module.network.private_subnet_1_id
  private_subnet_2_id = module.network.private_subnet_2_id
}
  
