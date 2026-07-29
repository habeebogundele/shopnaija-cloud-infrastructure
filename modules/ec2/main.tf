data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_launch_template" "this" {

  name_prefix   = "${var.project_name}-lt"

  image_id      = data.aws_ssm_parameter.amazon_linux.value

  instance_type = "t3.micro"

  vpc_security_group_ids = [
    var.ec2_sg
  ]

  iam_instance_profile {
    name = var.instance_profile
  }

  user_data = base64encode(
    file("${path.module}/userdata.sh")
  )
}

resource "aws_autoscaling_group" "this" {

  desired_capacity = 2

  min_size = 2

  max_size = 4

  vpc_zone_identifier = var.private_subnets

  target_group_arns = [

    var.target_group

  ]

  health_check_type = "ELB"

  launch_template {

    id = aws_launch_template.this.id

    version = "$Latest"

  }

}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.this.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.this.private_key_pem
  filename = "${var.project_name}.pem"

  file_permission = "0400"
}

