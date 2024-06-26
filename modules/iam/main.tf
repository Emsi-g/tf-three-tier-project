resource "aws_iam_instance_profile" "webapp_profile" {
  name                          = "${var.project_name}-webapp_profile"
  role                          = aws_iam_role.role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect                      = "Allow"

    principals {
      type                      = "Service"
      identifiers               = ["ec2.amazonaws.com"]
    }

    actions                     = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name                          = "${var.project_name}-webapp_role"
  path                          = "/"
  assume_role_policy            = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "attach_SSM" {
  policy_arn                    = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role                          = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "attach_s3readonly" {
  policy_arn                    = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role                          = aws_iam_role.role.name
}
