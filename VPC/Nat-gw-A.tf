variable "subnet_id_A" {
}


resource "aws_eip" "nat-A" {
  vpc = true
}


resource "aws_nat_gateway" "gw-A" {
  allocation_id = "${aws_eip.nat-A.id}"
  subnet_id     = var.subnet_id_A

  tags = {
    Name = "NAT-AZ-A"
  }
  depends_on = ["aws_internet_gateway.gw"]
}
