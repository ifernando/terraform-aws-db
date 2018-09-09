resource "aws_elasticache_subnet_group" "elasticache" {
  name        = "${local.fullname}"
  subnet_ids  = ["${var.db_subnet_ids}"]
  description = "${local.fullname}"
}

