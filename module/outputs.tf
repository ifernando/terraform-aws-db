output "region" {
  value = "${var.region}"
}

output "env" {
  value = "${var.environment}"
}

output "fullname" {
  value = "${local.fullname}"
}

output "globalname" {
  value = "${local.globalname}"
}

output "vpc_id" {
  value = "${data.aws_vpc.bitesize.id}"
}

output "vpc_cidr_block" {
  value = ["${data.aws_vpc.bitesize.cidr_block}"]
}

output "aws_security_group_db" {
  value = "${aws_security_group.db.name}"
}

output "aws_db_parameter_group_mysql56" {
  value = "${aws_db_parameter_group.mysql56.name}"
}

output "aws_db_parameter_group_mysql57" {
  value = "${aws_db_parameter_group.mysql57.name}"
}

output "rds_subnet_group" {
  value = "${aws_db_subnet_group.rds.name}"
}

output "elasticache_subnet_group" {
  value = "${aws_elasticache_subnet_group.elasticache.name}"
}

output "elasticsearch_instance_type" {
  value = "${var.elasticsearch_instance_type}"
}

output "elasticsearch_volume_size" {
  value = "${var.elasticsearch_volume_size}"
}

output "elasticsearch_name" {
  value = "${join("", aws_elasticsearch_domain.es.*.domain_name)}"
}

output "elasticsearch_domain_id" {
  value = "${join("", aws_elasticsearch_domain.es.*.domain_id)}"
}

output "elasticsearch_endpoint" {
  value = "${join("", aws_elasticsearch_domain.es.*.endpoint)}"
}

output "elasticsearch_arn" {
  value = "${join("", aws_elasticsearch_domain.es.*.arn)}"
}

output "grafana_mysql_identifier" {
  value = "${join("", aws_db_instance.grafana.*.identifier)}"
}

output "grafana_mysql_dbname" {
  value = "${join("", aws_db_instance.grafana.*.name)}"
}

output "grafana_mysql_arn" {
  value = "${join("", aws_db_instance.grafana.*.arn)}"
}

output "grafana_mysql_address" {
  value = "${join("", aws_db_instance.grafana.*.address)}"
}

output "grafana_mysql_endpoint" {
  value = "${join("", aws_db_instance.grafana.*.endpoint)}"
}

output "grafana_mysql_instance_type" {
  value = "${var.grafana_mysql_instance_type}"
}

output "keycloak_mysql_identifier" {
  value = "${join("", aws_db_instance.keycloak.*.identifier)}"
}

output "keycloak_mysql_dbname" {
  value = "${join("", aws_db_instance.keycloak.*.name)}"
}

output "keycloak_mysql_arn" {
  value = "${join("", aws_db_instance.keycloak.*.arn)}"
}

output "keycloak_mysql_address" {
  value = "${join("", aws_db_instance.keycloak.*.address)}"
}

output "keycloak_mysql_endpoint" {
  value = "${join("", aws_db_instance.keycloak.*.endpoint)}"
}

output "keycloak_mysql_instance_type" {
  value = "${var.keycloak_mysql_instance_type}"
}

output "aws_security_group_lambda" {
  value = "${aws_security_group.lambda.name}"
}

