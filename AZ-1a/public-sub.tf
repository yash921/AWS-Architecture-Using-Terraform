resource "aws_subnet" "public_A" {
  vpc_id     = var.my_Vpc_id
  cidr_block = "172.168.1.0/24"
  availability_zone = "ap-south-1a"
  #availability_zone_id = "aps1-az1"
  map_public_ip_on_launch = "true"
  

  tags = {
    Name = "Public-AZ-A"
  }
}


output "sub_public_A" {
  value = aws_subnet.public_A.id
}
