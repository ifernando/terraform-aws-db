provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${pathexpand(var.shared_credentials_file)}"
  max_retries             = "30"
}

provider "aws" {
  alias                   = "shared"
  region                  = "${var.remote_state_s3_region}"
  shared_credentials_file = "${pathexpand(var.shared_credentials_file)}"
  max_retries             = "30"
}

