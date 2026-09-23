output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_public_az1_id" {
  value = aws_subnet.public_az1.id
}

output "subnet_public_az2_id" {
  value = aws_subnet.public_az2.id
}

output "subnet_private_az1_id" {
  value = aws_subnet.private_az1.id
}

output "subnet_private_az2_id" {
  value = aws_subnet.private_az2.id
}

output "nacl_web_id" {
  value = aws_network_acl.web.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}

output "route_table_web_id" {
  value = aws_route_table.web.id
}