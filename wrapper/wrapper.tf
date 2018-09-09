data "terraform_remote_state" "core" {
  backend = "s3"

  config {
    bucket = "${var.s3_bucket}"
    key    = "${var.region}/${var.environment}/tfstate/core/terraform.tfstate"
    region = "eu-west-1"
  }
}

module "mod" {
  source = "../module"

  #
  # variables that can be overwritten by tfvars, but usually come from core
  #

  vpc_id = "${var.vpc_id != "" ? var.vpc_id : data.terraform_remote_state.core.vpc_id}"
  internal_zone_id = "${var.internal_zone_id != "" ? var.internal_zone_id : data.terraform_remote_state.core.internal_zone_id}"
  external_zone_id = "${var.external_zone_id != "" ? var.external_zone_id : data.terraform_remote_state.core.external_zone_id}"
  instance_subnet_ids     = "${data.terraform_remote_state.core.bitesize_backend_subnet_ids}"
  loadbalancer_subnet_ids = "${data.terraform_remote_state.core.bitesize_frontend_subnet_ids}"
  db_subnet_ids           = "${data.terraform_remote_state.core.bitesize_db_subnet_ids}"

  #
  # variables that can be overwritten by tfvars
  #

  environment             = "${var.environment}"
  environment_type        = "${var.environment_type}"
  region                  = "${var.region}"
  aws_key_name            = "${var.aws_key_name}"
  s3_bucket               = "${var.s3_bucket}"
  default_tags            = "${var.default_tags}"
  shared_credentials_file = "${var.shared_credentials_file}"
  internal_domain         = "${var.internal_domain}"
  remote_state_s3_region  = "${var.remote_state_s3_region}"
  elasticsearch_instance_count         = "${var.elasticsearch_instance_count}"
  elasticsearch_instance_type          = "${var.elasticsearch_instance_type}"
  elasticsearch_dedicated_master       = "${var.elasticsearch_dedicated_master}"
  elasticsearch_dedicated_master_count = "${var.elasticsearch_dedicated_master_count}"
  elasticsearch_volume_size            = "${var.elasticsearch_volume_size}"
  elasticsearch_encrypt_at_rest        = "${var.elasticsearch_encrypt_at_rest}"
  grafana_mysql_password               = "${var.grafana_mysql_password}"
  keycloak_mysql_password              = "${var.keycloak_mysql_password}"
  create_dbs                           = "${var.create_dbs}"
  skip_ansible = "${var.skip_ansible}"
}

