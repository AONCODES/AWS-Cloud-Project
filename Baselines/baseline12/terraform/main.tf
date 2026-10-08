/*
resource "aws_resourcegroups_group" "architect_course" {
  name = "ArchitectCourse"

  resource_query {
    query = jsonencode({
      ResourceTypeFilters = [
        "AWS::AllSupported"
      ]

      TagFilters = [
        {
          Key    = "Project"
          Values = ["architect course"]
        }
      ]
    })
  }
}
*/

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

module "backup" {
  source = "./modules/backup"

  vm_arn          = module.vm.vm_arn
  backup_role_arn = data.aws_iam_role.lab_role.arn
}

module "network" {
  source = "./modules/network"
  aws_region = var.aws_region
  vpc_cidr = var.vpc_cidr
  subnet_public_az1_cidr  = var.subnet_public_az1_cidr
  subnet_public_az2_cidr  = var.subnet_public_az2_cidr
  subnet_private_az1_cidr = var.subnet_private_az1_cidr
  subnet_private_az2_cidr = var.subnet_private_az2_cidr
}


module "vm" {
  source = "./modules/vm"
  aws_region = var.aws_region

  vpc_id = module.network.vpc_id
  subnet_id = module.network.subnet_public_az1_id
  private_subnet_id = module.network.subnet_private_az1_id

  vm_type = var.vm_type
  vm_keypair = var.vm_keypair
}

module "storage" {
  source = "./modules/storage"

  aws_region = var.aws_region
}

module "credentials" {
  source = "./modules/credentials"

  dummy_password = var.dummy_password
}

