# configure the provider
# provider "aws" {
#     region = "ap-south-1"
#     profile = "default"
# }

/*-----------------------------------------------------*/

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
/*----------------------------------------------------*/

# resource "aws_iam_role" "IamRole" {
#   name = "Ec2RoleForSSM"
#   assume_role_policy = <<POLICY

# # {
# #   "Version": "2012-10-17",
# #   "Statement": [
# #     {
# #       "Action": "sts:AssumeRole",
# #       "Principal": {
# #         "Service": ["ec2.amazonaws.com"]
# #       },
# #       "Effect": "Allow",
# #       "Sid": ""
# #     }
# #   ]
# # }

# POLICY
# }

# resource "aws_iam_instance_profile" "ec2InstanceProfile" {
#   role = "${aws_iam_role.IamRole.name}"
#   name = "Ec2RoleForSSM"
# }
# resource "aws_iam_role_policy_attachment" "IamRoleManagedPolicyRoleAttachment0" {
#   role = "${aws_iam_role.IamRole.name}"
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "ssmRole"
  }
}


# resource "aws_iam_role" "test_role" {
#   name = "test_role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }


resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = "${aws_iam_role.test_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                  "ec2messages:DeleteMessage",
                  "ec2messages:FailMessage",
                  "ec2messages:GetEndpoint",
                  "ec2messages:GetMessages",
                  "ec2messages:SendReply",
                  "ec2:DescribeInstanceStatus",
                  "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


# resource "aws_iam_role_policy_attachment" "test_attach" {
#   role       = "${aws_iam_role.test_role.name}"
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
# }

# resource "aws_ssm_activation" "foo" {
#   name               = "test_ssm_activation"
#   description        = "Test"
#   iam_role           = "${aws_iam_role.test_role.id}"
#   //registration_limit = "5"
#   depends_on         = ["aws_iam_role_policy_attachment.test_attach"]
# }



# /*-----------------------------------------------------*/

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = "${aws_iam_role.test_role.name}"
}
# /*-------------------------------------------------------*/
# /*
# resource "aws_iam_role_policy" "test_policy" {
#   name = "test_policy"
#   role = "${aws_iam_role.test_role.id}"

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ssm:*",
#                 "ec2:describeInstances",
#                 "iam:PassRole",
#                 "iam:ListRoles"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
# EOF
# }*/
/*-----------------------------------------------------*/
variable "subnet_id" {
}

resource "aws_instance" "web" {
    ami = "ami-09a7bbd08886aafdf"
    instance_type = "t2.micro"
    subnet_id = var.subnet_id
    key_name = aws_key_pair.generated_key.key_name
    iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
}

/*----------------------------------------*/

resource "aws_ssm_document" "foo" {
  name          = "test_document"
  document_type = "Command"
  content = <<DOC
  {
   "schemaVersion": "2.2",
   "description": "State Manager Bootstrap Example",
   "parameters": {},
   "mainSteps": [
      {
         "action": "aws:runShellScript",
         "name": "configureServer",
         "inputs": {
            "runCommand": [
               "sudo yum remove -y httpd",
               "sudo yum remove git -y"
            ]
         }
      }
   ]
}
DOC
}

# resource "aws_ssm_document" "foo" {
#   name          = "test_document"
#   document_type = "Command"

#   content = <<DOC
#   {
#     "schemaVersion": "1.2",
#     "description": "Check ip configuration of a Linux instance.",
#     "parameters": {

#     },
#     "runtimeConfig": {
#       "aws:runShellScript": {
#         "properties": [
#           {
#             "id": "0.aws:runShellScript",
#             "runCommand": ["ping -c 4 google.com"]
#           }
#         ]
#       }
#     }
#   }
# DOC
# }

/*------------------------------------*/

resource "aws_ssm_association" "example" {
  name = "${aws_ssm_document.foo.name}"

  targets {
    key    = "InstanceIds"
    values = ["${aws_instance.web.id}"]
  }
}


