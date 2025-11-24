output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

#output "ec2_public_ip" {
#  value = aws_instance.app_ec2.public_ip
#}

output "app_url" {
 # value = "http://${aws_instance.app_ec2.public_ip}:8080"
  value = "http://${aws_instance.web.public_ip}:8080"
}
