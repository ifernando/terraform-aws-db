output "db_sg" {
  value = "${module.mod.aws_security_group_db}"
}

output "elasticsearch_domain_id" {
  value = "${module.mod.elasticsearch_domain_id}"
}

output "elasticsearch_endpoint" {
  value = "${module.mod.elasticsearch_endpoint}"
}

output "elasticsearch_arn" {
  value = "${module.mod.elasticsearch_arn}"
}

output "grafana_mysql_arn" {
  value = "${module.mod.grafana_mysql_arn}"
}

output "grafana_mysql_endpoint" {
  value = "${module.mod.grafana_mysql_endpoint}"
}

output "grafana_mysql_address" {
  value = "${module.mod.grafana_mysql_address}"
}

