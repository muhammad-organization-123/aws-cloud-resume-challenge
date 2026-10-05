resource "aws_route53_zone" "website_zone" {
  name = local.my_domain
}




resource "aws_route53_record" "website_record" {
  zone_id = aws_route53_zone.website_zone.zone_id
  name    = local.my_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}
