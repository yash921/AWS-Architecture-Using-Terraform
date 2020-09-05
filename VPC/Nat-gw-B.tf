variable "subnet_id_B" {
}

resource "aws_eip" "nat-B" {
  vpc = true
}


resource "aws_nat_gateway" "gw-B" {
  allocation_id = "${aws_eip.nat-B.id}"
  subnet_id     = var.subnet_id_B

  tags = {
    Name = "NAT-AZ-B"
  }
  depends_on = ["aws_internet_gateway.gw"]
}
