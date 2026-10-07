output "instance_id" {
  value = aws_instance.vm.id
}

output "vm_public_ip" {
  value = aws_instance.vm.public_ip
}

output "vm_public_dns" {
  value = aws_instance.vm.public_dns
}