resource "aws_subnet" "public_B" {
  vpc_id     = var.my_Vpc_id_B
  cidr_block = "172.168.4.0/24"
  availability_zone = "ap-south-1b"
  #availability_zone_id = "aps1-az1"
  map_public_ip_on_launch = "true"
  

  tags = {
    Name = "Public-AZ-B"
  }
}

output "sub_public_B" {
  value = aws_subnet.public_B.id
}