# # resource "aws_lb" "frontend_lb" {
# #   name               = "frontend-lb"
# #   internal           = false
# #   load_balancer_type = "application"
# #   security_groups    = [aws_security_group.frontend_sg.id]
# #   subnets = [
# #     aws_subnet.public_subnet.id,
# #     aws_subnet.public_subnet_3.id
# #   ] # Add a second subnet here
# #
# #   tags = {
# #     Name = "frontend-lb"
# #   }
# # }
#
# resource "aws_lb" "backend_lb" {
#   name               = "backend-lb"
#   internal           = true
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.backend_sg.id]
#   subnets = [
#     aws_subnet.public_subnet.id,
#     aws_subnet.public_subnet_3.id
#   ]
#
#
#   tags = {
#     Name = "backend-lb"
#   }
# }
#
# # resource "aws_lb_target_group" "frontend_tg" {
# #   name        = "frontend-tg"
# #   port        = 80
# #   protocol    = "HTTP"
# #   vpc_id      = aws_vpc.ecommerce_vpc.id
# #   target_type = "instance"
# #
# #   health_check {
# #     path                = "/"
# #     interval            = 60
# #     timeout             = 5
# #     healthy_threshold   = 2
# #     unhealthy_threshold = 2
# #     protocol            = "HTTP"
# #   }
# #   tags = {
# #     Name = "frontend-target-group"
# #   }
# # }
#
# resource "aws_lb_target_group" "backend_tg" {
#   name        = "backend-tg"
#   port        = 3000
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.ecommerce_vpc.id
#   target_type = "instance"
#
#   health_check {
#     path                = "/"
#     interval            = 60
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     protocol            = "HTTP"
#   }
#   tags = {
#     Name = "backend-target-group"
#   }
# }
#
# # resource "aws_lb_listener" "frontend_listener" {
# #   load_balancer_arn = aws_lb.frontend_lb.arn
# #   port              = 80
# #   protocol          = "HTTP"
# #
# #   default_action {
# #     type             = "forward"
# #     target_group_arn = aws_lb_target_group.frontend_tg.arn
# #   }
# # }
#
# resource "aws_lb_listener" "backend_listener" {
#   load_balancer_arn = aws_lb.backend_lb.arn
#   port              = 3000
#   protocol          = "HTTP"
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.backend_tg.arn
#   }
# }

# Update to make the ALB internet-facing and rename it to backend-lb-2
resource "aws_lb" "backend_lb" {
  name               = "backend-lb-2" # Updated name
  internal           = false # Changed to false to make it internet-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.backend_sg.id]
  subnets = [
    aws_subnet.public_subnet.id,
    aws_subnet.public_subnet_3.id
  ]

  tags = {
    Name = "backend-lb-2"
  }
}

# Update the target group to listen on port 8000 and rename it to backend-tg-2
resource "aws_lb_target_group" "backend_tg" {
  name        = "backend-tg-2" # Updated name
  port        = 8000 # Changed port to 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ecommerce_vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = "HTTP"
  }
  tags = {
    Name = "backend-target-group-2"
  }
}

# Update the listener to use port 80
resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.backend_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}


