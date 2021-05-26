provider "aws" {
     region = "ap-south-1"
     profile = "YashAWS"
}

variable "Repo_Link" {
  description = "Application Code URL"
  type        = string
} 

variable "Repo_Name" {
  description = "The repo name in which code is present"
  type        = string
} 

module "My_VPC" {
     source = "./VPC"
     subnet_id_A = module.my_AZ_1a.sub_public_A
     subnet_id_B = module.my_AZ_1b.sub_public_B
     pub_AZ_A = module.my_AZ_1a.sub_public_A
     pub_AZ_B = module.my_AZ_1b.sub_public_B
     private_AZ_A = module.my_AZ_1a.sub_App_A
     private_AZ_B = module.my_AZ_1b.sub_App_B
     Data_AZ_A = module.my_AZ_1a.sub_Data_A
     Data_AZ_B = module.my_AZ_1b.sub_Data_B
}


module "my_AZ_1a" {
     source = "./AZ-1a"
     my_Vpc_id = module.My_VPC.id


     
}


module "my_AZ_1b" {
     source = "./AZ-1b"
     my_Vpc_id_B = module.My_VPC.id
}



module "ec2" {
     source = "./EC2"
     key_name = "my-key"
     pub_subnet_id_A = module.my_AZ_1a.sub_public_A
     pub_subnet_id_B = module.my_AZ_1b.sub_public_B
     pri_subnet_id_A = module.my_AZ_1a.sub_App_A
     pri_subnet_id_B = module.my_AZ_1b.sub_App_B
     Vpc_id_sg = module.My_VPC.id
     Git_url = var.Repo_Link
     Git_folder = var.Repo_Name
}