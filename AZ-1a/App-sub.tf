variable "my_Vpc_id" {
}

resource "aws_subnet" "private_App_A" {
  vpc_id     = var.my_Vpc_id
  cidr_block = "172.168.2.0/24"
  availability_zone = "ap-south-1a"
 # availability_zone_id = "aps1-az3"

  tags = {
    Name = "App-AZ-A"
  }
}

output "sub_App_A" {
  value = aws_subnet.private_App_A.id 
}