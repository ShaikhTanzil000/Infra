variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_private_subnet" {}
variable "eu_availability_zone" {}  
variable "cidr_public_subnet" {}

output "vpc_id" {
  value = aws_vpc.dev_proj_1_vpc_eu_central_1.id
}

output "public_subnet_cidr_block" {
  value = var.cidr_public_subnet
}

output "dev_proj_1_public_subnet" {
  value = aws_subnet.dev_proj_1_public_subnet
}

output "dev_proj_1_public_subnets" {
  value = aws_subnet.dev_proj_1_public_subnet[*].id
}

#setup VPC
resource "aws_vpc" "dev_proj_1_vpc_eu_central_1" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
  
}

#setup Public Subnet

resource "aws_subnet" "dev_proj_1_public_subnet" {
  count= length(var.cidr_public_subnet)  
  vpc_id = aws_vpc.dev_proj_1_vpc_eu_central_1.id
  cidr_block = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name = "dev-proj-public-subnet-${count.index + 1}"
  }
}

#setup Private Subnet

resource "aws_subnet" "dev_proj_1_private_subnet" {
  count= length(var.cidr_private_subnet)  
  vpc_id = aws_vpc.dev_proj_1_vpc_eu_central_1.id
  cidr_block = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name = "dev-proj-private-subnet-${count.index + 1}"
  }
  
}


#setup Internet Gateway

resource "aws_internet_gateway" "dev_proj_1_internet_gateway" {
  vpc_id = aws_vpc.dev_proj_1_vpc_eu_central_1.id

  tags = {
    Name = "dev-proj-internet-gateway"
  }
 
}

#setup Public Route Table 

resource "aws_route_table" "dev_proj_1_public_route_table" {
  vpc_id = aws_vpc.dev_proj_1_vpc_eu_central_1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_proj_1_internet_gateway.id
  }
  tags = {
    Name = "dev-proj-public-route-table"
  }
}


# Associate Public Subnet with Public Route Table

resource "aws_route_table_association" "dev_proj_1_public_subnet_rt_association" {
  count = length(var.cidr_public_subnet)
  subnet_id      = aws_subnet.dev_proj_1_public_subnet[count.index].id
  route_table_id = aws_route_table.dev_proj_1_public_route_table.id
}

#Setup Private Route Table

resource "aws_route_table" "dev_proj_1_private_route_table" {
  vpc_id = aws_vpc.dev_proj_1_vpc_eu_central_1.id
  tags = {
    Name = "dev-proj-private-route-table"
  }
}

# Associate Private Subnet with Private Route Table

resource "aws_route_table_association" "dev_proj_1_private_subnet_rt_association" {
  count = length(var.cidr_private_subnet)
  subnet_id      = aws_subnet.dev_proj_1_private_subnet[count.index].id
  route_table_id = aws_route_table.dev_proj_1_private_route_table.id
}



