variable "my_Vpc_id_B" {
}
resource "aws_subnet" "private_App_B" {
  vpc_id     = var.my_Vpc_id_B
  cidr_block = "172.168.5.0/24"
  availability_zone = "ap-south-1b"
 # availability_zone_id = "aps1-az3"

  tags = {
    Name = "App-AZ-B"
  }
}

output "sub_App_B" {
  value = aws_subnet.private_App_B.id
}