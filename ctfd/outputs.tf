# Public DNS name of the CTFd Application Load Balancer.

output "alb_dns_name" {
  description = "Public DNS name of the CTFd Application Load Balancer"
  value       = aws_lb.ctfd.dns_name
}

