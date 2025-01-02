# # resource "aws_route53_zone" "main_zone" {
# #   name = var.domain_name
# # }
#
# resource "aws_route53_record" "frontend_record" {
#   zone_id = aws_route53_zone.main_zone.zone_id
#   name    = "www"
#   type    = "A"
#   alias {
#     name                   = aws_lb.frontend_lb.dns_name
#     zone_id                = aws_lb.frontend_lb.zone_id
#     evaluate_target_health = true
#   }
# }
#
# resource "aws_route53_record" "backend_record" {
#   zone_id = aws_route53_zone.main_zone.zone_id
#   name    = "api"
#   type    = "A"
#   alias {
#     name                   = aws_lb.backend_lb.dns_name
#     zone_id                = aws_lb.backend_lb.zone_id
#     evaluate_target_health = true
#   }
# }
