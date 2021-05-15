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



resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = "${aws_iam_role.test_role.name}"
}


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
               "sudo yum install -y httpd",
               "sudo echo 'Git Commit Time!!' >> /var/www/html/index.html",
               "sudo systemctl start httpd"
            ]
         }
      }
   ]
}
DOC
}


resource "aws_ssm_association" "example" {
  name = "${aws_ssm_document.foo.name}"

  targets {
    key    = "InstanceIds"
    values = ["${aws_instance.web_A.id}",
              "${aws_instance.web_B.id}" ]
  }

}


