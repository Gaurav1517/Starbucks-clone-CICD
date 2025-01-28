# #Output the instance ID:
# output "instance_id" {
#   description = "The ID of the EC2 instance"
#   value       = aws_instance.web[0].id
# }

# # Output the public IP address:
# output "instance_public_ip" {
#   description = "The public IP address of the EC2 instance"
#   value       = aws_instance.web[0].public_ip
# }

# #Output the private IP address:
# output "instance_private_ip" {
#   description = "The private IP address of the EC2 instance"
#   value       = aws_instance.web[0].private_ip
# }

# Output the instance ID:
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web[0].id
}

# Output the public IP address with port 8080 for Jenkins:
output "instance_public_ip_with_jenkins_port" {
  description = "The public IP address of the EC2 instance with Jenkins port"
  value       = "http://${aws_instance.web[0].public_ip}:8080"
}

# Output the private IP address with port 8080 for Jenkins:
output "instance_private_ip_with_jenkins_port" {
  description = "The private IP address of the EC2 instance with Jenkins port"
  value       = "http://${aws_instance.web[0].private_ip}:8080"
}

# Output the public IP address with port 9000 for SonarQube:
output "instance_public_ip_with_sonarqube_port" {
  description = "The public IP address of the EC2 instance with SonarQube port"
  value       = "http://${aws_instance.web[0].public_ip}:9000"
}


