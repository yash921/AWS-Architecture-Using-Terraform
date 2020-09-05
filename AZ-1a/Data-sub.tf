resource "aws_subnet" "private_Data_A" {
  vpc_id     = var.my_Vpc_id
  cidr_block = "172.168.3.0/24"
  availability_zone = "ap-south-1a"
 # availability_zone_id = "aps1-az3"

  tags = {
    Name = "Data-AZ-A_database"
  }
}

output "sub_Data_A" {
  value = aws_subnet.private_Data_A.id
}