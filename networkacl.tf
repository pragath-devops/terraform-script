# Create Network ACL for public subnets
resource "aws_network_acl" "public_acl" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.public_zone_1.id, aws_subnet.public_zone_2.id, aws_subnet.public_zone_3.id]

  ## Inboud Rules
  ingress {
    rule_no    = 100
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    action     = "allow"
  }

  ## Outbound Rules
  egress {
    rule_no    = 100
    from_port  = "0"
    to_port    = "0"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  tags = {
    Name    = "dev_vpc_public_acl"
    Creator = "Terraform"
  }
}

# Create Network ACL for Private subnets
resource "aws_network_acl" "private_acl" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.private_zone_1.id, aws_subnet.private_zone_2.id, aws_subnet.private_zone_3.id]

  ## Inboud Rules
  ingress {
    rule_no    = 100
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    action     = "allow"
  }

  ## Outbound Rules
  egress {
    rule_no    = 100
    from_port  = "0"
    to_port    = "0"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  tags = {
    Name    = "dev_vpc_private_acl"
    Creator = "Terraform"
  }
}
