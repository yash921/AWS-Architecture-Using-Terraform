provider "aws" {
     region = "ap-south-1"
     profile = "YashAWS"
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
     subnet_id_A = module.my_AZ_1a.sub_public_A
     subnet_id_B = module.my_AZ_1b.sub_public_B
     Vpc_id_sg = module.My_VPC.id
}