variable "Vpc_id_sg" {}


resource "aws_security_group" "ExternalWeb" {
  name        = "ExternalWeb"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.Vpc_id_sg

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow web page"
  }
}




resource "aws_security_group" "InternalWeb" {
  name        = "InternalWeb"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.Vpc_id_sg

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.ExternalWeb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow web page internally"
  }
}

# resource "aws_security_group" "Database" {
#   name        = "Database"
#   description = "Allow database inbound traffic"
#   vpc_id      = var.Vpc_id_sg

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "MYSQL"
#     security_groups = [aws_security_group.InternalWeb.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "allow data to database"
#   }
# }



# resource "aws_security_group" "InternalEFS" {
#   name        = "InternalEFS"
#   description = "Allow EFS inbound traffic"
#   vpc_id      = var.Vpc_id_sg

#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = [aws_security_group.InternalEFS.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
  
#   tags = {
#     Name = "Allow EFS inbound traffic"
#   }
# }


