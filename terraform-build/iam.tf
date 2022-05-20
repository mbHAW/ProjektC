resource "aws_iam_role" "builder_role" {
  name = "helloapp-builder"

  assume_role_policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "codebuild.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "builder_policy" {
  name = "helloapp-builder"
  role = aws_iam_role.builder_role.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
              "arn:aws:s3:::projektc-${var.environment}-helloapp-builds",
              "arn:aws:s3:::projektc-${var.environment}-helloapp-builds/*"
            ],
            "Action": [
                "s3:*"
            ]
        }
    ]
}
  EOF
}
