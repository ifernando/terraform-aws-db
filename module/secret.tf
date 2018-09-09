provider "secret" {
  backend = "kms"

  config = {
    region                  = "eu-west-1"
    shared_credentials_file = "${pathexpand(var.shared_credentials_file)}"
  }
}

