variable "Vpc_id_sg" {}

resource "aws_security_group" "WP_internal_sg" {
  name        = "InternalWeb"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.Vpc_id_sg

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = ["${aws_security_group.SG1.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web_page"
  }
}

