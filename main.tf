locals {
  name_prefix = "${var.name_prefix}"
}

#creating a vpc
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = merge(
    var.tags,
    {
      "Name" = local.name_prefix
    },
  )
}

#attaching public and private subnets to the vpc
resource "aws_subnet" "private_subnetA" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-west-1a"

  tags = merge(
    var.tags,
    {
      "Name" = local.name_prefix
    },
  )
}

resource "aws_subnet" "private_subnetB" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1b"

  tags = merge(
    var.tags,
    {
      "Name" = local.name_prefix
    },
  )
}

resource "aws_subnet" "public_subnetA" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1a"

  tags = merge(
    var.tags,
    {
      "Name" = local.name_prefix
    },
  )
}

resource "aws_subnet" "public_subnetB" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-1b"

  tags = merge(
    var.tags,
    {
      "Name" = local.name_prefix
    },
  )
}

# Internet gateway for the public subnets
resource "aws_internet_gateway" "myInternetGateway" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      "Name" = local.name_prefix
    },
  )
}

# creating network access control list
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      "Name" = local.name_prefix
    },
  )
}
  
# Routing table for public subnets
resource "aws_route_table" "rtbpublic" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      "Name" = local.name_prefix
    },
  )
}

# Routing table for private subnets
resource "aws_route_table" "rtbprivate" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      "Name" = local.name_prefix
    },
  )
}

#creating network interface
resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

#creating multiple EC2 instances 
resource "aws_instance" "my-instance" {
  count         = var.instance_count
  ami           = lookup(var.ami,var.aws_region)
  instance_type = var.instance_type
  key_name      = aws_key_pair.terraform-demo.key_name
  user_data     = file("install_apache.sh")
  disable_api_termination = "false"
  monitoring    = "false"
  instance_initiated_shutdown_behavior = "stop"
  



  
}
