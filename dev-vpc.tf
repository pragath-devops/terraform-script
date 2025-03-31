## AWS Authentication

#provider "aws" {
#access_key = var.access_key
#secret_key = var.secret_key
#required_version = ">= 1.8.3"
#}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

terraform {
  required_version = ">= 1.5.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}



# Your AWS resources go here...





############## VPC CREATION #######################

## VPC Creation
resource "aws_vpc" "main" {
  cidr_block           = var.dev_vpc_cidr
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  enable_dns_support   = true

  tags = {
    Name        = var.dev_vpc_name
    Environment = "var.dev_vpc_environment"
    Creator     = "Terraform"
  }
}

############## PUBLIC SUBNET CREATION ################

## Create Public Subnet 1 in ap-south-1a 
resource "aws_subnet" "public_zone_1" {
  availability_zone       = var.zone_1a
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.dev_vpc_cidr_public_subnet_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name    = "dev_vpc_public_subnet_1a"
    Creator = "Terraform"
  }
}

## Create Public Subnet 2 in ap-south-1b
resource "aws_subnet" "public_zone_2" {
  availability_zone       = var.zone_1b
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.dev_vpc_cidr_public_subnet_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name    = "dev_vpc_public_subnet_1b"
    Creator = "Terraform"
  }
}

## Create Public Subnet 3 in ap-south-1c
resource "aws_subnet" "public_zone_3" {
  availability_zone       = var.zone_1c
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.dev_vpc_cidr_public_subnet_zone_3
  map_public_ip_on_launch = true

  tags = {
    Name    = "dev_vpc_public_subnet_1c"
    Creator = "Terraform"
  }
}

############## PRIVATE SUBNET CREATION #################
## Create Private Subnet 1 in ap-south-1a
resource "aws_subnet" "private_zone_1" {
  availability_zone = var.zone_1a
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.dev_vpc_cidr_private_subnet_zone_1

  tags = {
    Name    = "dev_vpc_private_subnet_1a"
    Creator = "Terraform"
  }
}
## Create Private Subnet 2 in ap-south-1b
resource "aws_subnet" "private_zone_2" {
  availability_zone = var.zone_1b
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.dev_vpc_cidr_private_subnet_zone_2

  tags = {
    Name    = "dev_vpc_private_subnet_1b"
    Creator = "Terraform"
  }
}

## Create Private Subnet 3 in ap-south-1c
resource "aws_subnet" "private_zone_3" {
  availability_zone = var.zone_1c
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.dev_vpc_cidr_private_subnet_zone_3

  tags = {
    Name    = "dev_vpc_private_subnet_1c"
    Creator = "Terraform"
  }
}

########################### CREATE IGW ################################
## Create Internet Gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "dev_vpc_internet_gateway"
    Creator = "Terraform"
  }
}

##################### Create VPC route tables for public subnets ######################

## Create  public route table for public subnets
resource "aws_route_table" "dev_vpc_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "dev_vpc_public_rt"
    Creator = "Terraform"
  }
}


##################### ASSOCIATE PUBLIC SUBNETS TO PUBLIC ROUTE TABLES ###################
## Assosiate public subnet 1 to public route table
resource "aws_route_table_association" "associate_zone_1" {
  subnet_id      = aws_subnet.public_zone_1.id
  route_table_id = aws_route_table.dev_vpc_rt.id
}

## Assosiate public subnet 2 to public route table
resource "aws_route_table_association" "associate_zone_2" {
  subnet_id      = aws_subnet.public_zone_2.id
  route_table_id = aws_route_table.dev_vpc_rt.id
}

## Assosiate public subnet 3 to public route table
resource "aws_route_table_association" "associate_zone_3" {
  subnet_id      = aws_subnet.public_zone_3.id
  route_table_id = aws_route_table.dev_vpc_rt.id
}


#################### CREATE ELASTIC IP #####################################

## Create EIPs
## Create EIP for 1
resource "aws_eip" "dev_vpc_eip_1" {
  domain = "vpc" # ✅ Correct
  tags = {
    Name    = "dev_vpc_eip_1"
    Creator = "Terraform"
  }
}

#################### CREATE NAT GATEWAY & ATTACH ELASTIC IP ###################

## Create NAT Gateways and attach 
## Create NAT Gateway 1 for availability zone 1a and attach to public subnet 1
resource "aws_nat_gateway" "dev_vpc_nat_gw_1" {
  allocation_id = aws_eip.dev_vpc_eip_1.id
  subnet_id     = aws_subnet.public_zone_1.id
  tags = {
    Name    = "dev_vpc-nat-gateway-1"
    Creator = "Terraform"
  }
}



##################### Create VPC route tables for private subnets ######################

## Create route table for private subnets
resource "aws_route_table" "dev_vpc_private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name    = "dev_vpc_private_rt"
    Creator = "Terraform"
  }
}

####### CREATE ROUTE FOR PRIVATE ROUTE TABLE #########################################

# Create route for private subnet 
resource "aws_route" "private_nat_route_1" {
  route_table_id         = aws_route_table.dev_vpc_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.dev_vpc_nat_gw_1.id
}

####################################################################################
# Assosiate private subnet 1 to private route table
resource "aws_route_table_association" "dev_vpc_private_rt_1" {
  subnet_id      = aws_subnet.private_zone_1.id
  route_table_id = aws_route_table.dev_vpc_private_rt.id
}

# Assosiate private subnet 2 to private route table
resource "aws_route_table_association" "dev_vpc_private_rt_2" {
  subnet_id      = aws_subnet.private_zone_2.id
  route_table_id = aws_route_table.dev_vpc_private_rt.id
}

# Assosiate private subnet 3 to private route table
resource "aws_route_table_association" "dev_vpc_private_rt_3" {
  subnet_id      = aws_subnet.private_zone_3.id
  route_table_id = aws_route_table.dev_vpc_private_rt.id
}
