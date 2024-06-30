data "aws_availability_zones" "available" {}

# DB Network
resource "aws_vpc" "db_vpc" {
  cidr_block = "10.0.0.0/16" 
  
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "db-vpc"
  }
}

resource "aws_subnet" "db_subnet" {
  count             = 2
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = element(["10.0.1.0/24", "10.0.2.0/24"], count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "db-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "db_igw" {
  vpc_id = aws_vpc.db_vpc.id

  tags = {
    Name = "db-igw"
  }
}

resource "aws_route_table" "db_route_table" {
  vpc_id = aws_vpc.db_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.db_igw.id
  }

  tags = {
    Name = "db-route-table"
  }
}

resource "aws_route_table_association" "db_route_table_assoc" {
  count          = 2
  subnet_id      = element(aws_subnet.db_subnet[*].id, count.index)
  route_table_id = aws_route_table.db_route_table.id
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.db_subnet[*].id

  tags = {
    Name = "db-subnet-group"
  }
}

output "db_vpc_id" {
  value = aws_vpc.db_vpc.id
}

output "db_subnet_ids" {
  value = aws_subnet.db_subnet[*].id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet_group.name
}

# ECS Network
resource "aws_vpc" "ecs_vpc" {
  cidr_block = "10.1.0.0/16"
  
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ecs-vpc"
  }
}

resource "aws_subnet" "ecs_public_subnet" {
  count             = 2
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = element(["10.1.1.0/24", "10.1.2.0/24"], count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "ecs-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "ecs_private_subnet" {
  count             = 2
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = element(["10.1.3.0/24", "10.1.4.0/24"], count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "ecs-private-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "ecs_igw" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "ecs-igw"
  }
}

resource "aws_nat_gateway" "ecs_nat_gateway" {
  count                   = 2
  allocation_id           = aws_eip.ecs_nat_eip[count.index].id
  subnet_id               = element(aws_subnet.ecs_public_subnet[*].id, count.index)
  connectivity_type       = "public"

  tags = {
    Name = "ecs-nat-gateway-${count.index}"
  }
}

resource "aws_eip" "ecs_nat_eip" {
  count  = 2
  domain = "vpc"

  tags = {
    Name = "ecs-nat-eip-${count.index}"
  }
}

resource "aws_route_table" "ecs_public_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_igw.id
  }

  tags = {
    Name = "ecs-public-route-table"
  }
}

resource "aws_route_table_association" "ecs_public_route_table_assoc" {
  count          = 2
  subnet_id      = element(aws_subnet.ecs_public_subnet[*].id, count.index)
  route_table_id = aws_route_table.ecs_public_route_table.id
}

resource "aws_route_table" "ecs_private_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.ecs_nat_gateway[*].id, 0)
  }

  tags = {
    Name = "ecs-private-route-table"
  }
}

resource "aws_route_table_association" "ecs_private_route_table_assoc" {
  count          = 2
  subnet_id      = element(aws_subnet.ecs_private_subnet[*].id, count.index)
  route_table_id = aws_route_table.ecs_private_route_table.id
}

output "ecs_vpc_id" {
  value = aws_vpc.ecs_vpc.id
}

output "ecs_public_subnet_ids" {
  value = aws_subnet.ecs_public_subnet[*].id
}

output "ecs_private_subnet_ids" {
  value = aws_subnet.ecs_private_subnet[*].id
}