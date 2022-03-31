# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  tags                 = merge({ "Name" : var.tags.Project }, var.tags)
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# alb_subnets_for_alb
resource "aws_subnet" "alb" {
  for_each          = { for s in var.alb_subnets : s.name => s }
  cidr_block        = each.value.cidr_block
  vpc_id            = aws_vpc.main.id
  availability_zone = each.value.az
  tags              = merge({ "Name" = "${var.tags.Project}-${each.key}" }, var.tags)
}

# private_subnets_for_containers
resource "aws_subnet" "private" {
  for_each          = { for s in var.private_subnets : s.name => s }
  cidr_block        = each.value.cidr_block
  vpc_id            = aws_vpc.main.id
  availability_zone = each.value.az
  tags              = merge({ "Name" = "${var.tags.Project}-${each.key}" }, var.tags)
}

# InternetGateWay
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = merge({ "Name" = "${var.tags.Project}-ig" }, var.tags)
}

# VPC RouteTable
resource "aws_route_table" "alb" {
  vpc_id = aws_vpc.main.id
  tags   = merge({ "Name" : "${var.tags.Project}-route-alb" }, var.tags)
}

# route to connect internet_gatway
resource "aws_route" "alb_to_igw" {
  route_table_id         = aws_route_table.alb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = merge({ "Name" : "${var.tags.Project}-route-private" }, var.tags)
}

# RouteTableAssociation for alb
resource "aws_route_table_association" "alb" {
  for_each       = { for sb in var.alb_subnets : sb.name => sb }
  subnet_id      = aws_subnet.alb[each.key].id
  route_table_id = aws_route_table.alb.id
}

# RouteTableAssociation for pribate
resource "aws_route_table_association" "private" {
  for_each       = { for sb in var.private_subnets : sb.name => sb }
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}
