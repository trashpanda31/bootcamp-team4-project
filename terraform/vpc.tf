data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az1 = data.aws_availability_zones.available.names[0]
  az2 = data.aws_availability_zones.available.names[1]
}

resource "aws_vpc" "team4" {
  cidr_block           = "10.40.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = "CloudSprint-team4-vpc" })
}

resource "aws_internet_gateway" "team4" {
  vpc_id = aws_vpc.team4.id
  tags   = merge(var.tags, { Name = "CloudSprint-team4-igw" })
}

resource "aws_subnet" "team4_public_az1" {
  vpc_id                  = aws_vpc.team4.id
  cidr_block              = "10.40.1.0/24"
  availability_zone       = local.az1
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = "CloudSprint-team4-public-az1" })
}

resource "aws_subnet" "team4_public_az2" {
  vpc_id                  = aws_vpc.team4.id
  cidr_block              = "10.40.2.0/24"
  availability_zone       = local.az2
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = "CloudSprint-team4-public-az2" })
}

resource "aws_route_table" "team4_public" {
  vpc_id = aws_vpc.team4.id
  tags   = merge(var.tags, { Name = "CloudSprint-team4-rt-public" })
}

resource "aws_route" "team4_public_default" {
  route_table_id         = aws_route_table.team4_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.team4.id
}

resource "aws_route_table_association" "team4_public_az1" {
  subnet_id      = aws_subnet.team4_public_az1.id
  route_table_id = aws_route_table.team4_public.id
}

resource "aws_route_table_association" "team4_public_az2" {
  subnet_id      = aws_subnet.team4_public_az2.id
  route_table_id = aws_route_table.team4_public.id
}

resource "aws_eip" "team4_nat" {
  domain = "vpc"
  tags   = merge(var.tags, { Name = "CloudSprint-team4-nat-eip" })
}

resource "aws_nat_gateway" "team4" {
  allocation_id = aws_eip.team4_nat.id
  subnet_id     = aws_subnet.team4_public_az1.id

  tags = merge(var.tags, { Name = "CloudSprint-team4-nat" })

  depends_on = [aws_internet_gateway.team4]
}

resource "aws_subnet" "team4_private_az1" {
  vpc_id            = aws_vpc.team4.id
  cidr_block        = "10.40.11.0/24"
  availability_zone = local.az1

  tags = merge(var.tags, { Name = "CloudSprint-team4-private-az1" })
}

resource "aws_subnet" "team4_private_az2" {
  vpc_id            = aws_vpc.team4.id
  cidr_block        = "10.40.12.0/24"
  availability_zone = local.az2

  tags = merge(var.tags, { Name = "CloudSprint-team4-private-az2" })
}

resource "aws_route_table" "team4_private" {
  vpc_id = aws_vpc.team4.id
  tags   = merge(var.tags, { Name = "CloudSprint-team4-rt-private" })
}

resource "aws_route" "team4_private_default" {
  route_table_id         = aws_route_table.team4_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.team4.id
}

resource "aws_route_table_association" "team4_private_az1" {
  subnet_id      = aws_subnet.team4_private_az1.id
  route_table_id = aws_route_table.team4_private.id
}

resource "aws_route_table_association" "team4_private_az2" {
  subnet_id      = aws_subnet.team4_private_az2.id
  route_table_id = aws_route_table.team4_private.id
}

locals {
  public_subnet_ids  = [aws_subnet.team4_public_az1.id, aws_subnet.team4_public_az2.id]
  private_subnet_ids = [aws_subnet.team4_private_az1.id, aws_subnet.team4_private_az2.id]
}
