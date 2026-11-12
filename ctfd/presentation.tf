
# Internet facing ALB distributes HTTP requests across CTFd application servers in two Availability Zones.
resource "aws_lb" "ctfd" {
  name               = "ctfd-alb"
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb.id]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  tags = {
    Name = "ctfd_alb"
  }
}

# Target Group for CTFd application servers.

resource "aws_lb_target_group" "ctfd" {
  name        = "ctfd-target-group"
  port        = 8000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  # Check that CTFd responds to HTTP requests. using defaults 
  health_check {
    path                = "/"
    matcher             = "200-399"
    healthy_threshold   = 2
  }

  tags = {
    Name = "ctfd_target_group"
  }
}

# HTTP Listener
# Forward incoming HTTP requests to the CTFd target group.

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ctfd.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ctfd.arn
  }
}