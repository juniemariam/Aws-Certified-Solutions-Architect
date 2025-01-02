resource "aws_iam_role" "backend_ec2_role" {
  name = "backend-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "secrets_access_policy" {
  name        = "secrets-access-policy"
  description = "Policy to allow access to Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "secretsmanager:GetSecretValue",
        Resource = "arn:aws:secretsmanager:us-west-1:640168430849:secret:ecommerce-db-secrets"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backend_ec2_role_attachment" {
  role       = aws_iam_role.backend_ec2_role.name
  policy_arn = aws_iam_policy.secrets_access_policy.arn
}
