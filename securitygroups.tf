# Create private Security Group 
resource "aws_security_group" "dev_private_sg" {
  name        = "dev_vpc_private_sg"
  description = "Allow all internal traffic"
  vpc_id      = aws_vpc.main.id

  #Define ingress rules inbound traffic (private)

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  #Define egress rules for outbound traffic (private)

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic to any IPv4 address
  }

  tags = {
    Name    = "dev_vpc_private_sg"
    Creator = "Terraform"
  }
}


# Create public Security Group 
resource "aws_security_group" "dev_vpc_public_sg" {
  name        = "dev_vpc_public_sg"
  description = "Allow all internal & external traffic"
  vpc_id      = aws_vpc.main.id

  #Define ingress rules for inbound traffic (public)

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }


  #Define egress outbound traffic (public)

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic to any IPv4 address
  }

  tags = {
    Name    = "dev_vpc_public_sg"
    Creator = "Terraform"
  }
}
