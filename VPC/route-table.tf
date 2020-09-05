resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = "${aws_vpc.main.id}"
  route_table_id = "${aws_route_table.public.id}"
}

variable "pub_AZ_A" {
  
}
resource "aws_route_table_association" "b" {
  subnet_id      = var.pub_AZ_A
  route_table_id = aws_route_table.public.id
}

variable "pub_AZ_B" {
  
}
resource "aws_route_table_association" "c" {
  subnet_id      = var.pub_AZ_B
  route_table_id = aws_route_table.public.id
}

#############################################################

resource "aws_route_table" "private-A" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.gw-A.id}"
  }

  tags = {
    Name = "private-route-table-A"
  }
}


resource "aws_route_table" "private-B" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.gw-B.id}"
  }

  tags = {
    Name = "private-route-table-B"
  }
}

variable "private_AZ_A" {
  
}
resource "aws_route_table_association" "d" {
  subnet_id      = var.private_AZ_A
  route_table_id = aws_route_table.private-A.id
}

variable "Data_AZ_A" {
  
}
resource "aws_route_table_association" "e" {
  subnet_id      = var.Data_AZ_A
  route_table_id = aws_route_table.private-A.id
}


variable "private_AZ_B" {
  
}
resource "aws_route_table_association" "f" {
  subnet_id      = var.private_AZ_B
  route_table_id = aws_route_table.private-B.id
}

variable "Data_AZ_B" {
  
}
resource "aws_route_table_association" "g" {
  subnet_id      = var.Data_AZ_B
  route_table_id = aws_route_table.private-B.id
}