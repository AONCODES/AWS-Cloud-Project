output "instance_id" {
  value = aws_instance.web.id
}

output "web_ip" {
  value = aws_instance.web.public_ip
}

output "web_dns" {
  value = aws_instance.web.public_dns
}