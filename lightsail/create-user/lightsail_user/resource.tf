
terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "4.32.0"

    }

  }

}

provider "aws" {

  region = "us-east-1"

  profile = "terraform"

}

resource "aws_iam_user" "iam_user" {

  name = "user-${var.user_name}"

}

resource "aws_iam_group" "iam_group" {

  name = "iam_group-${var.user_name}"

}

resource "aws_iam_policy" "iam_policy" {

  name = "iam_policy-${var.user_name}"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "lightsail:*",
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })

}

resource "aws_iam_policy_attachment" "iam_policy_attachment" {

  name = "aws_iam_policy_attachment-${var.user_name}"

  users = [aws_iam_user.iam_user.name]

  groups = [aws_iam_group.iam_group.name]

  policy_arn = aws_iam_policy.iam_policy.arn

}

resource "aws_iam_access_key" "iam_access_key" {

  user = aws_iam_user.iam_user.id

  # pgp_key = "keybase:some_person_that_exists" 

}
