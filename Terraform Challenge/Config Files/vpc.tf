# Crear VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.cidr_block_vpc
  tags = {
    Name = "MainVPC"
  }
}

# Crear Subnet dentro de la VPC
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.cidr_block_subnet
  availability_zone = "us-east-1a"
  tags = {
    Name = "MainSubnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "MainIGW"
  }
}

# Create Route Table
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "MainRouteTable"
  }
}

# Create a Route to the Internet
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.main_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "main_subnet_association" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}

# Crear un Security Group
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "allow_http"
  }
  depends_on = [aws_vpc.main_vpc]
}

# Create ingress rule for security group
resource "aws_security_group_rule" "allow_tls_ipv4" {
  type              = "ingress"
  security_group_id = aws_security_group.allow_http.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}

# Create ingress rule for security group
resource "aws_security_group_rule" "allow_ssh_from_console" {
  type              = "ingress"
  security_group_id = aws_security_group.allow_http.id
  cidr_blocks       = ["18.206.107.24/29"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

# Create egress rule for security group
resource "aws_security_group_rule" "allow_all_traffic_ipv4" {
  type              = "egress"
  security_group_id = aws_security_group.allow_http.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # All protocols
}