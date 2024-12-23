resource "aws_iam_role" "ec2_access" {
  name = "EC2AccessS3Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }

    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name   = "EC2AccessS3Policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
      Action   = ["s3:GetObject", "s3:ListBucket"],
      Effect   = "Allow",
      Resource = [
        "arn:aws:s3:::${aws_s3_bucket.my_bucket.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.my_bucket.bucket}/*"]
      },
      {
        Action   = ["s3:GetObject", "s3:ListBucket"],
        Effect   = "Allow",
        Resource = [
          "arn:aws:s3:::my-bucket-571600871347",
          "arn:aws:s3:::my-bucket-571600871347/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_access_s3_attachment" {
  role       = aws_iam_role.ec2_access.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_instance_profile" "ec2_access" {
  name = "MyEC2AccessProfile"
  role = aws_iam_role.ec2_access.name
}
