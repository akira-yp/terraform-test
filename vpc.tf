# vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

# Subnet
resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 11)
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.prefix}-public-subnet-1c"
  }
}


resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 21)
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.prefix}-private-subnet-1c"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 31)
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.prefix}-private-subnet-1a"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-public-route"
  }
}

resource "aws_route" "to_internet" {
  route_table_id         = aws_route_table.public_rt.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_rt_1c" {
  subnet_id      = aws_subnet.public_subnet_1c.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-private-route"
  }
}

resource "aws_route_table_association" "private_rt_1c" {
  subnet_id      = aws_subnet.private_subnet_1c.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_1a" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.private_rt.id
}

# security group
resource "aws_security_group" "app" {
  name   = "${var.prefix}-dev-app-sg"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.prefix}-dev-app-sg"
  }
}

resource "aws_security_group" "db" {
  name   = "${var.prefix}-dev-db-sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-dev-db-sg"
  }
}

resource "aws_security_group_rule" "db-in" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app.id
  security_group_id        = aws_security_group.db.id
}

resource "aws_security_group_rule" "db-out" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db.id
}




