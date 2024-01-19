provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "cust-vpc" {
  cidr_block = "192.168.10.0/24"

  tags = {
    Name = "mumbai-vpc"
  }
}


resource "aws_subnet" "pub-sub" {
  vpc_id = aws_vpc.cust-vpc.id
  cidr_block = "192.168.10.0/25"
  
  tags = {
    Name = "Pub-sub"
  }
}

resource "aws_subnet" "pri-sub" {
  vpc_id = aws_vpc.cust-vpc.id
  cidr_block = "192.168.10.128/25"

  tags = {
    Name = "Pri-sub"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.cust-vpc.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "Pub-rt" {
  vpc_id = aws_vpc.cust-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "Pub-rt"
  }
}

resource "aws_route_table" "Pri-rt" {
  vpc_id = aws_vpc.cust-vpc.id

  tags = {
    Name = "Pri-rt"
  }
}

resource "aws_route_table_association" "pr-1" {
  subnet_id = aws_subnet.pub-sub.id
  route_table_id = aws_route_table.Pub-rt.id
}


resource "aws_route_table_association" "pr-2" {
  subnet_id = aws_subnet.pri-sub.id
  route_table_id = aws_route_table.Pri-rt.id
}

