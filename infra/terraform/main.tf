terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


resource "aws_ecrpublic_repository" "repo" {
  repository_name = "cloud-infra-demo"
  force_destroy = true
}

resource "aws_iam_user" "github" {
  name = "github"
  force_destroy = true
}

resource "aws_iam_access_key" "github" {
  user = "${aws_iam_user.github.name}"
}

resource "aws_iam_user_policy" "github_ecr" {
  name = "github_ecr"
  user = aws_iam_user.github.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr-public:GetAuthorizationToken",
                "sts:GetServiceBearerToken",
                "ecr-public:BatchCheckLayerAvailability",
                "ecr-public:GetRepositoryPolicy",
                "ecr-public:DescribeRepositories",
                "ecr-public:DescribeRegistries",
                "ecr-public:DescribeImages",
                "ecr-public:DescribeImageTags",
                "ecr-public:GetRepositoryCatalogData",
                "ecr-public:GetRegistryCatalogData",
                "ecr-public:InitiateLayerUpload",
                "ecr-public:UploadLayerPart",
                "ecr-public:CompleteLayerUpload",
                "ecr-public:PutImage"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}