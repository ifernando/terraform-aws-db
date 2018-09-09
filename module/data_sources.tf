data "aws_caller_identity" "current" {}

data "secret" "grafana_mysql_password" {
  encrypted_value = "${var.grafana_mysql_password}"
}

data "secret" "keycloak_mysql_password" {
  encrypted_value = "${var.keycloak_mysql_password}"
}

data "aws_kms_alias" "ssm" {
  name = "alias/aws/ssm"
}

data "aws_route53_zone" "external" {
  zone_id = "${var.external_zone_id}"
}

data "aws_route53_zone" "internal" {
  zone_id = "${var.internal_zone_id}"
}

data "aws_vpc" "bitesize" {
  id = "${var.vpc_id}"
}

data "aws_region" "shared" {
  provider = "aws.shared"
  current  = true
}

data "aws_subnet_ids" "dbsubnets" {
  vpc_id = "${var.vpc_id}"

  tags {
    Type = "db"
  }
}

data "template_file" "delete_dbs" {
  template = "${file("${path.module}/files/delete_dbs.py")}"
}

data "aws_iam_policy_document" "es-indices-cleanup" {

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
}

  statement {
    actions = [
      "es:ESHttpDelete",
      "es:ESHttpGet",
      "es:ESHttpHead",
      "es:ESHttpPost",
      "es:ESHttpPut",
    ]

    resources = [
      "*",
    ]
}

}


