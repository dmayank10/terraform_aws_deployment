terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}

# # key pair (public and private)
# resource "tls_private_key" "rsa-4096-key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "local_file" "key" {
#   content  = tls_private_key.rsa-4096-key.private_key_pem
#   filename = "my-key"
# } 

# resource "aws_key_pair" "my_keypair" {
#   key_name   = "my-key"
#   public_key = tls_private_key.rsa-4096-key.public_key_openssh
# }

# instances
resource "aws_instance" "frontend_instance" {
    ami = var.ami_id
    instance_type = var.public_instance
    subnet_id = aws_subnet.public_subnet.id
    associate_public_ip_address = true
    security_groups = [aws_security_group.public_sg.id]
    # key_name = aws_key_pair.my_keypair.key_name
    tags = {
      Name = "frontend_instance"
    }
}

# resource "aws_instance" "backend_instance" {
#     ami = var.ami_id
#     instance_type = var.private_instance
#     subnet_id = aws_subnet.private_subnet.id
#     associate_public_ip_address = false
#     security_groups = [aws_security_group.public_sg.id]
#     key_name = aws_key_pair.my_keypair.key_name
#     tags = {
#       Name = "backend_instance"
#     }
# }

# vpc
resource "aws_vpc" "app_vpc" {
    cidr_block = "10.0.0.0/16"
}

# security group
resource "aws_security_group" "public_sg" {
    name = "public_sg"
    vpc_id = aws_vpc.app_vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_security_group" "private_sg" {
#     name = "private_sg"
#     vpc_id = aws_vpc.app_vpc.id
#     ingress {
#         from_port = 22
#         to_port = 22
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
#     egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = "10.0.0.0/17"
}

# resource "aws_subnet" "private_subnet" {
#   vpc_id = aws_vpc.app_vpc.id
#   cidr_block = "10.0.128.0/17"
# }

# # elastic ip
# resource "aws_eip" "eip" {
#     domain = "vpc"
# }

# # igw, NAT gw
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.app_vpc.id
# }

# resource "aws_nat_gateway" "nat" {
#   connectivity_type = "public"
#   subnet_id = aws_subnet.public_subnet.id
#   allocation_id = aws_eip.eip.id
# }

# # route table
# resource "aws_route_table" "public_route" {
#   vpc_id = aws_vpc.app_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
# }

# resource "aws_route_table" "private_route" {
#   vpc_id = aws_vpc.app_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat.id
#   }
# }

# # route table association
# resource "aws_route_table_association" "public_association" {
#   route_table_id = aws_route_table.public_route.id
#   subnet_id = aws_subnet.public_subnet.id
# }

# resource "aws_route_table_association" "private_association" {
#   route_table_id = aws_route_table.private_route.id
#   subnet_id = aws_subnet.private_subnet.id
# }