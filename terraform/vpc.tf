#Define CIDR Block for Network Segment
resource "aws_vpc" "main" {
   cidr_block = "10.0.0.0/24"
    tags = {
      Name = "devops-vpc"
    }
 }

#Public Subnet
 resource "aws_subnet" "public" {
   vpc_id            = aws_vpc.main.id
   cidr_block        = "10.0.0.0/25"
   tags = {
     Name = "devops-public-subnet"
   }
 }

#Private Subnet
resource "aws_subnet" "private" {
   vpc_id            = aws_vpc.main.id
   cidr_block        = "10.0.0.128/25"
   tags = {
     Name = "devops-private-subnet"
   }
 }

#Internet Gateway
 resource "aws_internet_gateway" "igw" {
   vpc_id = aws_vpc.main.id
   tags = {
     Name = "devops-igw"
   }
 }

#Elastic IP
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "devops-nat-eip"
  }
}

#NAT Gateway
 resource "aws_nat_gateway" "nat" {
   allocation_id = aws_eip.nat.id
   subnet_id     = aws_subnet.public.id
   depends_on = [aws_internet_gateway.igw]
   tags = {
     Name = "devops-ngw"
   }
 }

#Public Route Table
 resource "aws_route_table" "public_rt" {
   vpc_id = aws_vpc.main.id
   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.igw.id
   }
    tags = {
      Name = "devops-public-route"
    }
 }

#Links Public Bubnet with the Public Route Table
 resource "aws_route_table_association" "public" {
   subnet_id      = aws_subnet.public.id
   route_table_id = aws_route_table.public_rt.id
 }

#Private Route Table
 resource "aws_route_table" "private_rt" {
   vpc_id = aws_vpc.main.id
   route {
     cidr_block = "0.0.0.0/0"
     nat_gateway_id = aws_nat_gateway.nat.id
   }
   tags = {
     Name = "devops-private-route"
   }
 }  
#Links Private Subnet with the Private Route Table
 resource "aws_route_table_association" "private" {
   subnet_id      = aws_subnet.private.id
   route_table_id = aws_route_table.private_rt.id
 }