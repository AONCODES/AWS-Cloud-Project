# Launch Template for CTFd application servers, ubuntu.

resource "aws_launch_template" "ctfd" {
  image_id      = "ami-08b275ac6cc5dbefb"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]
  
  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
  docker_compose = file("${path.module}/docker-compose.yml")
}))

  tags = {
    Name = "ctfd_launch_template"
  }
}

# Auto Scaling Group for CTFd application servers.

resource "aws_autoscaling_group" "ctfd" {
  name             = "ctfd_asg"
  min_size         = 2
  max_size         = 3
  desired_capacity = 2
  
  health_check_grace_period = 300

  vpc_zone_identifier = [
    aws_subnet.private_app_a.id,
    aws_subnet.private_app_b.id
  ]

  target_group_arns = [
    aws_lb_target_group.ctfd.arn
  ]

  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.ctfd.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ctfd_ec2"
    propagate_at_launch = true
  }
}

# Scale EC2 instances based on average CPU utilization.

resource "aws_autoscaling_policy" "ctfd_cpu" {
  name                   = "ctfd_cpu_scaling"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.ctfd.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }
}