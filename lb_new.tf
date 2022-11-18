resource "aws_lb" "main" {
  name               = "${var.load_balancer_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${data.aws_security_groups.single.ids[0]}"]
  subnets            = ["${data.aws_subnet.selected1.id}", "${data.aws_subnet.selected2.id}"]
 
  enable_deletion_protection = false
}
 
resource "aws_alb_target_group" "main" {
  name        = "${var.load_balancer_name}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected.id
  target_type = "ip"
 
  health_check {
   healthy_threshold   = "3"
   interval            = "30"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "3"
   path                = "/"
   unhealthy_threshold = "2"
  }
}
#==============================
output "LOAN-BALANCER-DNS" {
    value = aws_lb.main.dns_name
}

#==========================
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"
 
  default_action {
   type = "redirect"
 
   redirect {
     port        = 443
     protocol    = "HTTPS"
     status_code = "HTTP_301"
   }
  }
}
 
resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.main.id
  port              = 443
  protocol          = "HTTPS"
 
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_tls_cert_arn
 
  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}