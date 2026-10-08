output "instance_id" {
  value = aws_instance.vm.id
}

output "vm_public_ip" {
  value = aws_instance.vm.public_ip
}

output "vm_public_dns" {
  value = aws_instance.vm.public_dns
}

output "custom_ami_id"{
  value = aws_ami_from_instance.custom_ami.id
}
output "image_vm_public_ip" {
  value = aws_instance.image_vm.public_ip
}
output "vm_arn" {
  description = "ARN of the VM"
  value       = aws_instance.vm.arn
}

output "private_vm_private_ip" {
  description = "Private IP address of the private VM"
  value       = aws_instance.private_vm.private_ip
}