resource "aws_launch_template" "this" {

  name_prefix = "${var.project_name}-lt"

  image_id = var.ami

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

