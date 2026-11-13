# Launch Template for CTFd application servers, ubuntu.

resource "aws_launch_template" "ctfd" {
  image_id      = "ami-08b275ac6cc5dbefb"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  # Use the existing AWS Academy IAM instance profile. Should use probaly more restricted iam role but due to restricitons we go with LabRole
  iam_instance_profile {
  name = "LabInstanceProfile"
}

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
  docker_compose = file("${path.module}/docker-compose.yml")

  db_host    = aws_db_instance.ctfd.address
  db_name    = aws_db_instance.ctfd.db_name
  db_user    = aws_db_instance.ctfd.username
  secret_arn = aws_db_instance.ctfd.master_user_secret[0].secret_arn

  redis_host = aws_elasticache_cluster.ctfd.cache_nodes[0].address
  aws_region = "us-east-1"
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