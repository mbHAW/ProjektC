resource "aws_codebuild_project" "helloapp" {
  name         = "helloapp"
  service_role = aws_iam_role.builder_role.arn

  artifacts {
    type                   = "S3"
    location               = aws_s3_bucket.artifact_bucket.id
    packaging              = "NONE"
    override_artifact_name = true
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/myHAW/helloapp.git"
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  source_version = "main"
}

data "aws_ssm_parameter" "github_access_token" {
  name = "/build/github-access-token"
}

resource "aws_codebuild_source_credential" "github_credential" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = data.aws_ssm_parameter.github_access_token.value
}
