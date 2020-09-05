resource "aws_subnet" "private_Data_B" {
  vpc_id     = var.my_Vpc_id_B
  cidr_block = "172.168.6.0/24"
  availability_zone = "ap-south-1b"
 # availability_zone_id = "aps1-az3"

  tags = {
    Name = "Data-AZ-B_database"
  }
}

output "sub_Data_B" {
  value = aws_subnet.private_Data_B.id
}