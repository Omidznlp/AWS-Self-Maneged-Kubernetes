resource "aws_security_group" "custom-sg-public" {
  name = "custom-sg-public"
  description = "custom-sg-public"
  vpc_id = aws_vpc.customvpc.id
  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_groups = ["${aws_security_group.alb-securitygroup.id}"]
  }
  // To allow workers to join master 
ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.custom-sg-private.id}"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group" "custom-sg-private" {
  name = "custom-sg-private"
  description = "custom-sg-private"
  vpc_id = aws_vpc.customvpc.id
  // To Allow all port 
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.custom-sg-public.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
#Security group for AWS ELB
resource "aws_security_group" "alb-securitygroup" {
  vpc_id      = aws_vpc.customvpc.id
  name        = "elb-sg"
  description = "security group for Application Load Balancer"
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "elb-sg"
  }
}
