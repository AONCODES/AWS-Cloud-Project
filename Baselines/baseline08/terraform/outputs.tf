output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_public_az1_id" {
  value = module.network.subnet_public_az1_id
}

output "subnet_public_az2_id" {
  value = module.network.subnet_public_az2_id
}

output "subnet_private_az1_id" {
  value = module.network.subnet_private_az1_id
}

output "subnet_private_az2_id" {
  value = module.network.subnet_private_az2_id
}

output "nacl_public_id" {
  value = module.network.nacl_public_id
}

output "nacl_private_id" {
  value = module.network.nacl_private_id
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

output "vm_public_ip" {
  value = module.vm.vm_public_ip
}

output "vm_public_dns" {
  value = module.vm.vm_public_dns
}


output "public_storage_name" {
  value = module.storage.public_storage_name
}

output "protected_storage_name" {
  value = module.storage.protected_storage_name
}