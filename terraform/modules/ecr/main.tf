# ECR
resource "aws_ecr_repository" "main" {
  name                 = "${var.ecr_repository_image}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

# ECR Policy
resource "aws_ecr_repository_policy" "main" {
  repository = "${aws_ecr_repository.main.name}"

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "AllowPushPull",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload"
            ]
        }
    ]
}
EOF
}

# SSM Parameter 
resource "aws_ssm_parameter" "ecr_url" {
  name  ="ECR_REPO_URL"
  description = "Parameter to be used to push the docker image"
  type  = "SecureString"
  value =  "${aws_ecr_repository.main.repository_url}"
  overwrite = true
}