provider "aws" {
    region = "us-east-2"
}


########## VPC ##########

resource "aws_vpc" "vpc_challenge" {
  cidr_block = "12.0.0.0/16"
  tags = {
    Name = "vpc_challenge"
  }
}


########## PUBLIC SUBNET ##########

resource "aws_subnet" "public_subnet_challenge_a" {
  vpc_id = aws_vpc.vpc_challenge.id
  cidr_block = "12.0.32.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "public_subnet_challenge_a"
  }
}

resource "aws_subnet" "public_subnet_challenge_b" {
  vpc_id = aws_vpc.vpc_challenge.id
  cidr_block = "12.0.33.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "public_subnet_challenge_b"
  }
}

resource "aws_subnet" "public_subnet_challenge_c" {
  vpc_id = aws_vpc.vpc_challenge.id
  cidr_block = "12.0.34.0/24"
  availability_zone = "us-east-2c"
  tags = {
    Name = "public_subnet_challenge_c"
  }
}


########## APPLICATION SUBNET ##########

resource "aws_subnet" "application_subnet_challenge_a" {
  vpc_id = aws_vpc.vpc_challenge.id
  cidr_block = "12.0.8.0/21"
  availability_zone = "us-east-2a"
  tags = {
    Name = "application_subnet_challenge_a"
  }
}

resource "aws_subnet" "application_subnet_challenge_b" {
  vpc_id = aws_vpc.vpc_challenge.id
  cidr_block = "12.0.16.0/21"
  availability_zone = "us-east-2b"
  tags = {
    Name = "application_subnet_challenge_b"
  }
}

resource "aws_subnet" "application_subnet_challenge_c" {
  vpc_id = aws_vpc.vpc_challenge.id
  cidr_block = "12.0.24.0/21"
  availability_zone = "us-east-2c"
  tags = {
    Name = "application_subnet_challenge_c"
  }
}


########## INTERNET GATEWAY ##########

resource "aws_internet_gateway" "gw_challenge" {
  vpc_id = aws_vpc.vpc_challenge.id
  tags = {
    Name = "internet_gateway_challenge"
  }
}

resource "aws_eip" "eip_gw_challenge" {
  vpc = true
  depends_on = [
    aws_internet_gateway.gw_challenge
  ]
}

resource "aws_nat_gateway" "nat_gw_challenge" {
  allocation_id = aws_eip.eip_gw_challenge.id
  subnet_id = aws_subnet.public_subnet_challenge_a.id
  depends_on = [
    aws_internet_gateway.gw_challenge
  ]
  tags = {
    Name = "nat_gateway_challenge"
  }
}

resource "aws_route" "internet_access" {
  route_table_id = aws_vpc.vpc_challenge.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw_challenge.id
}


########## PRIVATE ROUTES ##########

resource "aws_route_table" "private_route_table_challenge" {
  vpc_id = aws_vpc.vpc_challenge.id
  tags = {
    Name = "private_route_table_challenge"
  }
}

resource "aws_route" "private_route_challenge" {
  route_table_id = aws_route_table.private_route_table_challenge.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw_challenge.id
}

resource "aws_route_table_association" "application_subnet_challenge_a_association" {
  subnet_id = aws_subnet.application_subnet_challenge_a.id
  route_table_id = aws_route_table.private_route_table_challenge.id
}

resource "aws_route_table_association" "application_subnet_challenge_b_association" {
  subnet_id = aws_subnet.application_subnet_challenge_b.id
  route_table_id = aws_route_table.private_route_table_challenge.id
}

resource "aws_route_table_association" "application_subnet_challenge_c_association" {
  subnet_id = aws_subnet.application_subnet_challenge_c.id
  route_table_id = aws_route_table.private_route_table_challenge.id
}


########## PUBLIC ROUTES ##########

resource "aws_route_table" "public_route_table_challenge" {
  vpc_id = aws_vpc.vpc_challenge.id
  tags = {
    Name = "public_route_table_challenge"
  }
}

resource "aws_route" "public_route_challenge" {
  route_table_id = aws_route_table.public_route_table_challenge.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw_challenge.id
}

resource "aws_route_table_association" "public_subnet_challenge_a_association" {
  subnet_id = aws_subnet.public_subnet_challenge_a.id
  route_table_id = aws_route_table.public_route_table_challenge.id
}

resource "aws_route_table_association" "public_subnet_challenge_b_association" {
  subnet_id = aws_subnet.public_subnet_challenge_b.id
  route_table_id = aws_route_table.public_route_table_challenge.id
}

resource "aws_route_table_association" "public_subnet_challenge_c_association" {
  subnet_id = aws_subnet.public_subnet_challenge_c.id
  route_table_id = aws_route_table.public_route_table_challenge.id
}