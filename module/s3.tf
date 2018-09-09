resource "aws_s3_bucket_object" "delete_dbs" {
  provider = "aws.shared"
  bucket   = "${var.s3_bucket}"
  key      = "${var.region}/${var.environment}/files/${local.name}/delete_dbs.py"
  content  = "${data.template_file.delete_dbs.rendered}"
}

