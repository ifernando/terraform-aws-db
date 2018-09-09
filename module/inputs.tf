variable "vpc_id" {
  default = ""
}

variable "default_tags" {
  type    = "map"
  default = {}
}

variable "elasticsearch_instance_count" {
  default = 2
}

variable "elasticsearch_dedicated_master" {
  default = false
}

variable "elasticsearch_dedicated_master_count" {
  default = 0
}

variable "elasticsearch_volume_size" {
  default = 10
}

variable "elasticsearch_instance_type" {
  default = "t2.small.elasticsearch"
}

variable "elasticsearch_encrypt_at_rest" {
  default = false
}

variable "create_dbs" {
  default = 1
}

variable "grafana_mysql_password" {
  default = "AQICAHgtTQGsSDH8txmi3mOt4SDnq6Nb8/3yzY8w/EIHs4S6PAEgBvHQ1fLUyRiTeF2UNMJAAAAAZjBkBgkqhkiG9w0BBwagVzBVAgEAMFAGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMzGlNWoSpXGLGIhdEAgEQgCPzHHWhge9LUE0an9yUMulVDgf1mThNMOGSlgLQDq3zN/mvIg=="
}

variable "keycloak_mysql_password" {
  default = "AQICAHgYz4rU+T1BgxqKrTBbkewBE5evpcnSKpB2QUcDDyOYDQGVQdQoI2vXaCo532vBtH0cAAAAZjBkBgkqhkiG9w0BBwagVzBVAgEAMFAGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMJvvNwQTrdfsWYETTAgEQgCNLOH5D8cFYoCXgv2UjxZ782SaWFpHAF0+1c3HxPRUcXe1b7Q=="
}

variable "grafana_mysql_instance_type" {
  default = "db.t2.micro"
}

variable "keycloak_mysql_instance_type" {
  default = "db.t2.micro"
}

variable "log_retention_in_days" {
  description = "Days to retain logs in CloudWatch"
  default     = "90"
}

variable "s3_bucket" {}

variable "environment" {}

variable "environment_type" {
  default = "dev"
}

variable "region" {
  default = "eu-west-1"
}

variable "external_zone_id" {
  default = ""
}

variable "internal_zone_id" {
  default = ""
}

variable "internal_domain" {
  default = "dev"
}

variable "shared_credentials_file" {
  default = "~/.aws/credentials"
}

variable "remote_state_s3_region" {
  default = "eu-west-1"
}

variable "aws_key_name" {
  default = "bitesize"
}

variable "instance_subnet_ids" {
  type    = "list"
  default = []
}

variable "loadbalancer_subnet_ids" {
  type    = "list"
  default = []
}

variable "db_subnet_ids" {
  type    = "list"
  default = []
}

variable "skip_ansible" {
  default = "false"
}

variable "role" {
  default = "db"
}

# Variables for Lambda function which will delete indices older than a certain no: of days 
variable "prefix" {
  default = "lambda"
}

variable "schedule" {
  default = "cron(0 3 * * ? *)"
}

variable "sns_alert" {
  description = "SNS ARN to pusblish any alert"
  default     = ""
}

variable "es_endpoint" {
  default     = ""
}

variable "index" {
  description = "Index/indices to process comma separated, with all every index will be processed except '.kibana'"
  default     = "all"
}

variable "es_delete_after" {
  description = "Numbers of days to preserve"
  default     = 15
}

variable "index_format" {
  description = "Combined with 'index' varible is used to evaluate the index age"
  default     = "%Y.%m.%d"
}

variable "python_version" {
  default = "2.7"
}


