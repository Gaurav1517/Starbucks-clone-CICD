resource "aws_security_group" "ec2_security_group" {
  name        = var.ec2_security_group
  description = "Allow SSH, HTTP, HTTPS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "${var.ec2_security_group}"
  }
}

# Ingress rule for SSH (port 22) - IPv4
resource "aws_security_group_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.ec2_security_group.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Ingress rule for HTTP (port 80) - IPv4
resource "aws_security_group_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.ec2_security_group.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Ingress rule for HTTPS (port 443) - IPv4
resource "aws_security_group_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.ec2_security_group.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
# Ingress rule for application (port 3000) - IPv4
resource "aws_security_group_rule" "allow_application_ipv4" {
  security_group_id = aws_security_group.ec2_security_group.id
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
# Ingress rule for email-notification (port 465) - IPv4
resource "aws_security_group_rule" "allow_email-notification_ipv4" {
  security_group_id = aws_security_group.ec2_security_group.id
  type              = "ingress"
  from_port         = 465
  to_port           = 465
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
# Ingress rule for sonarqube (port 9000) - IPv4
resource "aws_security_group_rule" "allow_sonarqube_ipv4" {
  security_group_id = aws_security_group.ec2_security_group.id
  type              = "ingress"
  from_port         = 9000
  to_port           = 9000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
# Ingress rule for jenkins (port 8000) - IPv4
resource "aws_security_group_rule" "allow_jenkins_ipv4" {
  security_group_id = aws_security_group.ec2_security_group.id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}


# Egress rule for all traffic - IPv4
resource "aws_security_group_rule" "allow_all_outbound_ipv4" {
  security_group_id = aws_security_group.ec2_security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

