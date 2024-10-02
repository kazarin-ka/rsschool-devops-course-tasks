# Create IAM role
resource "aws_iam_role" "GithubActionsRole" {
  name               = "GithubActionsRole"
  assume_role_policy = data.aws_iam_policy_document.GithubActionsRole.json
  tags               = local.sec_tags
}

data "aws_iam_policy_document" "GithubActionsRole" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:iss"
      values   = ["https://token.actions.githubusercontent.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:kazarin-ka/rsschool-devops-course-tasks:*", "repo:rolling-scopes-school/kazarin-ka-AWSDEVOPS2024Q3:*"]
    }
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::205930612148:oidc-provider/token.actions.githubusercontent.com"]
    }
  }
}

# Attach AmazonEC2FullAccess policy
resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.GithubActionsRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Attach AmazonRoute53FullAccess policy
resource "aws_iam_role_policy_attachment" "route53_full_access" {
  role       = aws_iam_role.GithubActionsRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

# Attach AmazonS3FullAccess policy
resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.GithubActionsRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Attach IAMFullAccess policy
resource "aws_iam_role_policy_attachment" "iam_full_access" {
  role       = aws_iam_role.GithubActionsRole.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

# Attach AmazonVPCFullAccess policy
resource "aws_iam_role_policy_attachment" "vpc_full_access" {
  role       = aws_iam_role.GithubActionsRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

# Attach AmazonSQSFullAccess policy
resource "aws_iam_role_policy_attachment" "sqs_full_access" {
  role       = aws_iam_role.GithubActionsRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

# Attach AmazonEventBridgeFullAccess policy
resource "aws_iam_role_policy_attachment" "eventbridge_full_access" {
  role       = aws_iam_role.GithubActionsRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
}
