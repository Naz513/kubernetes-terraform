output "instance_ip_workernode" {
  description = "The public IP of the jenkins server."
  value       = aws_instance.WorkerNode.*.public_dns
}

output "instance_ip_masternode_ssh" {
  description = "SSH command to MasterNode"
  value       = "ssh -i terraform-key.pem ubuntu@${aws_instance.MasterNode.public_dns}"
}

output "instance_ip_masternode_ip" {
  description = "The public IP of the jenkins server."
  value       = aws_instance.MasterNode.public_ip
}

output "amzn_ami" {
  description = "The AMI that will be used to provision this Server."
  value       = data.aws_ami.latest_ubuntu_ami.name
}