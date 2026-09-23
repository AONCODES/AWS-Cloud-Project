output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_web_id" {
  value = aws_subnet.web.id
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