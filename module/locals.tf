locals {
  name = "${var.role}"

  asg_tags = [
    {
      key                 = "Environment"
      value               = "${lookup("${var.default_tags}", "Environment")}"
      propagate_at_launch = true
    },
    {
      key                 = "EnvironmentType"
      value               = "${lookup("${var.default_tags}", "EnvironmentType")}"
      propagate_at_launch = true
    },
  ]

  internal_domain = "${replace("${data.aws_route53_zone.internal.name}", "/[.]$/", "")}"
  external_domain = "${replace("${data.aws_route53_zone.external.name}", "/[.]$/", "")}"

  fullname   = "${var.role}-${var.environment}-${var.environment_type}"
  globalname = "${var.role}-${var.environment}-${var.region}-${var.environment_type}"
}

