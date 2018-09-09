resource "aws_route53_record" "elasticsearch" {
  count   = "${var.create_dbs}"
  zone_id = "${var.internal_zone_id}"
  name    = "elasticsearch"
  type    = "CNAME"
  ttl     = 5
  records = ["${aws_elasticsearch_domain.es.0.endpoint}"]
}

resource "aws_route53_record" "grafanadb" {
  count   = "${var.create_dbs}"
  zone_id = "${var.internal_zone_id}"
  name    = "grafanadb"
  type    = "CNAME"
  ttl     = 5
  records = ["${aws_db_instance.grafana.0.address}"]
}

resource "aws_route53_record" "keycloakdb" {
  count   = "${var.create_dbs}"
  zone_id = "${var.internal_zone_id}"
  name    = "keycloakdb"
  type    = "CNAME"
  ttl     = 5
  records = ["${aws_db_instance.keycloak.0.address}"]
}

