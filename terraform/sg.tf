#Public Security Group
resource "aws_security_group" "public_sg" {
   name        = "devops-public-sg"
   description = "Allow HTTP and SSH traffic"
   vpc_id      = aws_vpc.main.id

   ingress {
     from_port   = 80
     to_port     = 80
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]    
    }
    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.128/25"]   
    }
    
    #Monitoring Server IP (Prometheus Node Export)
    ingress {
      from_port   = 9100
      to_port     = 9100
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.128/25"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "devops-public-sg"
    }
   }

#below code is private server security group
resource "aws_security_group" "private_sg" {
   name        = "devops-private-sg"
   description = "Allow only SSH traffic from VPC"
   vpc_id      = aws_vpc.main.id

   ingress {
     from_port   = 22
     to_port     = 22
     protocol    = "tcp"
     cidr_blocks = ["10.0.0.0/24"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "devops-private-sg"
    }
  }
