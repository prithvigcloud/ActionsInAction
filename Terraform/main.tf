terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}



resource "aws_iam_openid_connect_provider" "github" {
url    = "https://token.actions.githubusercontent.com"
client_id_list = ["sts.amazonaws.com"]
thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github_actions" {
  name = "github-actions-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
      Effect = "Allow"
      Principal = {
        Federated =  aws_iam_openid_connect_provider.github.arn 
        }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:prithvigcloud/ActionsInAction:ref:refs/heads/main"
          }
      }
  }]
  })
  }  
