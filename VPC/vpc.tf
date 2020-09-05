resource "aws_vpc" "main" {
  cidr_block       = "172.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "Wordpress-Vps"
  }
}


output "id" {
  value = aws_vpc.main.id
}


# #####---Nat Gateway---########
# resource "aws_nat_gateway" "gw" {
#   allocation_id = "${aws_eip.nat.id}"
#   subnet_id     = "${aws_subnet.example.id}"

#   tags = {
#     Name = "gw NAT"
#   }
# }




# resource "aws_route_table_association" "b" {
#   gateway_id     = aws_internet_gateway.gw.id
#   route_table_id = aws_route_table.r.id
# }
