resource "aws_cloudwatch_log_group" "es_index" {
  count             = "${var.create_dbs}"
  name              = "/bitesize-${var.environment}-${var.environment_type}/${data.aws_vpc.bitesize.id}/elasticsearch/index_slow_logs"
  retention_in_days = "${var.log_retention_in_days}"
}

resource "aws_cloudwatch_log_group" "es_search" {
  count             = "${var.create_dbs}"
  name              = "/bitesize-${var.environment}-${var.environment_type}/${data.aws_vpc.bitesize.id}/elasticsearch/search_slow_logs"
  retention_in_days = "${var.log_retention_in_days}"
}

resource "aws_cloudwatch_log_resource_policy" "es" {
  count       = "${var.create_dbs}"
  policy_name = "es_cloudwatch_logs"

  policy_document = <<CONFIG
  {
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": [
        "${aws_cloudwatch_log_group.es_index.arn}",
        "${aws_cloudwatch_log_group.es_search.arn}"
      ]
    }]
  }
CONFIG

  depends_on = [
    "aws_cloudwatch_log_group.es_index",
    "aws_cloudwatch_log_group.es_search",
  ]
}

resource "aws_elasticsearch_domain" "es" {
  count                 = "${var.create_dbs}"
  domain_name           = "podlogs-${var.environment}-${var.environment_type}"
  elasticsearch_version = "6.2"

  cluster_config {
    instance_type            = "${var.elasticsearch_instance_type}"
    instance_count           = "${var.elasticsearch_instance_count}"
    dedicated_master_enabled = "${var.elasticsearch_dedicated_master}"
    dedicated_master_count   = "${var.elasticsearch_dedicated_master_count}"
    zone_awareness_enabled   = true
  }

  vpc_options {
    subnet_ids         = ["${var.db_subnet_ids[0]}", "${var.db_subnet_ids[1]}"]
    security_group_ids = ["${aws_security_group.db.id}"]
  }

  encrypt_at_rest {
    enabled = "${var.elasticsearch_encrypt_at_rest}"
  }

  advanced_options {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = "${var.elasticsearch_volume_size}"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.es_index.arn}"
    log_type                 = "INDEX_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.es_search.arn}"
    log_type                 = "SEARCH_SLOW_LOGS"
  }

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        ]
      },
      "Action": "",
      "Resource": "arn:aws:es:${var.region}::domain/podlogs-${var.environment}-${var.environment_type}/*"
    }
  ]
}
CONFIG

  tags = "${merge(var.default_tags, map(
    "Name", "${local.fullname}",
    "Domain", "${local.fullname}"
  ))}"

  depends_on = [
    "aws_cloudwatch_log_resource_policy.es",
  ]
}

