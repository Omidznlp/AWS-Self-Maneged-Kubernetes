resource "aws_lb" "alb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-securitygroup.id]
  subnets            = [aws_subnet.subnet-public-1.id, aws_subnet.subnet-public-2.id]
  enable_deletion_protection = false

  tags = {
    Environment = "test"
  }
}

resource "aws_lb_target_group" "alb-tg" {
  name     = "tg-alb"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.customvpc.id
}

resource "aws_lb_listener" "listener_lb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}