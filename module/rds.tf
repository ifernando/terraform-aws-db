resource "aws_db_parameter_group" "mysql57" {
  name   = "${local.fullname}-mysql57"
  family = "mysql5.7"

  parameter {
    name  = "innodb_file_format"
    value = "Barracuda"
  }

  parameter {
    name  = "general_log"
    value = "1"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }

  parameter {
    name  = "long_query_time"
    value = "3"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }
}

resource "aws_db_parameter_group" "mysql56" {
  name   = "${local.fullname}-mysql56"
  family = "mysql5.6"

  parameter {
    name  = "innodb_file_format"
    value = "Barracuda"
  }

  parameter {
    name  = "general_log"
    value = "1"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }

  parameter {
    name  = "long_query_time"
    value = "3"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }
}

resource "aws_db_subnet_group" "rds" {
  name        = "${local.fullname}"
  subnet_ids  = ["${var.db_subnet_ids}"]
  description = "${local.fullname}"

  tags = "${merge(var.default_tags, map(
    "Name", "${local.fullname}"
  ))}"
}

resource "aws_db_instance" "grafana" {
  count = "${var.create_dbs}"

  allocated_storage           = 10
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "${var.grafana_mysql_instance_type}"
  name                        = "grafana"
  identifier                  = "grafana${var.environment}${var.environment_type}"
  username                    = "admin"
  password                    = "${data.secret.grafana_mysql_password.value}"
  parameter_group_name        = "${local.fullname}-mysql57"
  db_subnet_group_name        = "${aws_db_subnet_group.rds.name}"
  final_snapshot_identifier   = "grafana-${local.fullname}"
  vpc_security_group_ids      = ["${aws_security_group.db.id}"]
  allow_major_version_upgrade = true

  tags = "${merge(var.default_tags, map(
    "Name", "grafana-${local.fullname}"
  ))}"

  depends_on = [
    "aws_db_parameter_group.mysql57",
  ]
}

resource "aws_db_instance" "keycloak" {
  count                       = "${var.create_dbs}"
  allocated_storage           = 10
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "${var.keycloak_mysql_instance_type}"
  name                        = "keycloak"
  identifier                  = "keycloak${var.environment}${var.environment_type}"
  username                    = "keycloak"
  password                    = "${data.secret.keycloak_mysql_password.value}"
  parameter_group_name        = "${local.fullname}-mysql57"
  db_subnet_group_name        = "${aws_db_subnet_group.rds.name}"
  final_snapshot_identifier   = "keycloak-${local.fullname}"
  vpc_security_group_ids      = ["${aws_security_group.db.id}"]
  allow_major_version_upgrade = true

  tags = "${merge(var.default_tags, map(
    "Name", "keycloak-${local.fullname}"
  ))}"

  depends_on = [
    "aws_db_parameter_group.mysql57",
  ]
}

