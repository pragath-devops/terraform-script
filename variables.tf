variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "aws_profile" {
  type    = string
  default = "ashok-dev" # Change this to your AWS profile name
  sensitive = true
}

#variable "access_key" {
#default = "*****************"
#}

#variable "secret_key" {
# default = "*******************"
#}

# Defines Availability Zones
variable "zone_1a" {
  default = "ap-south-1a"
}
variable "zone_1b" {
  default = "ap-south-1b"
}
variable "zone_1c" {
  default = "ap-south-1c"
}


####Defines VPC CIDR
variable "dev_vpc_cidr" {
  default = "10.10.0.0/16"
}

##### Defines CIDR for public AZs######
# Defines CIDR for public AZ 1a
variable "dev_vpc_cidr_public_subnet_zone_1" {
  default = "10.10.0.0/22"
}
# Defines CIDR for public AZ 1b
variable "dev_vpc_cidr_public_subnet_zone_2" {
  default = "10.10.4.0/22"
}
# Defines CIDR for public AZ 1c
variable "dev_vpc_cidr_public_subnet_zone_3" {
  default = "10.10.8.0/22"
}


######## Defines CIDR for private AZs###################
# Defines CIDR for private AZ 1a
variable "dev_vpc_cidr_private_subnet_zone_1" {
  default = "10.10.12.0/22"
}
# Defines CIDR for private AZ 1b
variable "dev_vpc_cidr_private_subnet_zone_2" {
  default = "10.10.16.0/22"
}
# Defines CIDR for private AZ 1c
variable "dev_vpc_cidr_private_subnet_zone_3" {
  default = "10.10.20.0/22"
}

# Defines VPC name
variable "dev_vpc_name" {
  default = "dev_vpc"
}

# Defines VPC environment
variable "dev_vpc_environment" {
  default = "Dev"
}
