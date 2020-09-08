# creating a key pair
variable "key_name" {}



resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

# saving key to local file
resource "local_file" "deploy-key" {
    content  = tls_private_key.example.private_key_pem
    filename = "/home/yash/tf_key.pem"
}




variable "subnet_id_A" {}

resource "aws_instance" "web_A" {
    ami = "ami-09a7bbd08886aafdf"
    instance_type = "t2.micro"
    subnet_id = var.subnet_id_A
    vpc_security_group_ids = [aws_security_group.WP_internal_sg.id]
    key_name = aws_key_pair.generated_key.key_name
    iam_instance_profile = aws_iam_instance_profile.test_profile.name
}


variable "subnet_id_B" {}

resource "aws_instance" "web_B" {
    ami = "ami-09a7bbd08886aafdf"
    instance_type = "t2.micro"
    subnet_id = var.subnet_id_B
    vpc_security_group_ids = [aws_security_group.WP_internal_sg.id]
    key_name = aws_key_pair.generated_key.key_name
    iam_instance_profile = aws_iam_instance_profile.test_profile.name
}

