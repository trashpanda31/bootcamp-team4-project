data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_internet_gateway" "this" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_nat_gateways" "this" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

locals {
  az1 = data.aws_availability_zones.available.names[0]
  az2 = data.aws_availability_zones.available.names[1]

  nat_gateway_id = length(data.aws_nat_gateways.this.ids) > 0 ? data.aws_nat_gateways.this.ids[0] : null
}

resource "aws_subnet" "team4-public-az1" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.40.1.0/24"
  availability_zone       = local.az1
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = "CloudSprint-team4-public-az1" })
}

resource "aws_subnet" "team4-public-az2" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.40.2.0/24"
  availability_zone       = local.az2
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = "CloudSprint-team4-public-az2" })
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = "CloudSprint-team4-rt-public" })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "team4_private_az1" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.40.11.0/24"
  availability_zone = local.az1

  tags = merge(var.tags, { Name = "CloudSprint-team4-private-az1" })
}

resource "aws_subnet" "team4_private_az2" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.40.12.0/24"
  availability_zone = local.az2

  tags = merge(var.tags, { Name = "CloudSprint-team4-private-az2" })
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = "CloudSprint-team4-rt-private" })
}

resource "aws_route" "private_default" {
  count                  = local.nat_gateway_id == null ? 0 : 1
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = local.nat_gateway_id
}

resource "aws_route_table_association" "private_az1" {
  subnet_id      = aws_subnet.private_az1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_az2" {
  subnet_id      = aws_subnet.private_az2.id
  route_table_id = aws_route_table.private.id
}

locals {
  public_subnet_ids  = [aws_subnet.team4-public-az1.id, aws_subnet.team4-public-az2.id]
  private_subnet_ids = [aws_subnet.team4-private-az1.id, aws_subnet.team4-private-az2.id]
}
