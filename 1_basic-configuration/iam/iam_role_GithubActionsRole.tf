# Create IAM role
resource "aws_iam_role" "GithubActionsRole" {
  name = "GithubActionsRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"  # TODO - replace with GitHub Actions OIDC provider
      },
    }],
  })
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
