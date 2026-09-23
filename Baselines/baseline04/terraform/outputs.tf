output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_web_id" {
  value = module.network.subnet_web_id
}

output "aws_network_acl" {
  value = module.network.nacl_web_id
}

output "internet_gateway_id" {
  value = module.network.internet_gateway_id
}

output "route_table_web_id" {
  value = module.network.route_table_web_id
}


output "instance_id" {
  value = module.vm.instance_id
}

output "web_ip" {
  value = module.vm.web_ip
}

output "web_dns" {
  value = module.vm.web_dns
}