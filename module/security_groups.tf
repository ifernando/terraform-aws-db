resource "aws_security_group" "db" {
  name        = "${local.fullname}"
  description = "Allow access to databases from front and backend instances"

  # mysql
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${concat(list("${data.aws_vpc.bitesize.cidr_block}", "192.168.0.0/16"))}"]
    description = "mysql"
  }

  # postgres
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${concat(list("${data.aws_vpc.bitesize.cidr_block}", "192.168.0.0/16"))}"]
    description = "postgres"
  }

  # mongo
  ingress {
    from_port   = 27017
    to_port     = 27018
    protocol    = "tcp"
    cidr_blocks = ["${concat(list("${data.aws_vpc.bitesize.cidr_block}", "192.168.0.0/16"))}"]
    description = "mongo"
  }

  # couchbase
  # Note: CouchBase depends on Cassandra and Memcached ingress ports
  ingress {
    from_port   = 11210
    to_port     = 11210
    protocol    = "tcp"
    cidr_blocks = ["${concat(list("${data.aws_vpc.bitesize.cidr_block}", "192.168.0.0/16"))}"]
    description = "couchbase"
  }

  ingress {
    from_port   = 9131
    to_port     = 9131
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.bitesize.cidr_block}"]
    description = "couchbase-exporter"
  }

  ingress {
    from_port   = 8091
    to_port     = 8094
    protocol    = "tcp"
    cidr_blocks = ["${concat(list("${data.aws_vpc.bitesize.cidr_block}", "192.168.0.0/16"))}"]
    description = "couchbase-admin"
  }

  ingress {
    from_port   = 18091
    to_port     = 18094
    protocol    = "tcp"
    cidr_blocks = ["${concat(list("${data.aws_vpc.bitesize.cidr_block}", "192.168.0.0/16"))}"]
    description = "couchbase-admin-ssl"
  }

  ingress {
    from_port   = 4369
    to_port     = 4369
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.bitesize.cidr_block}"]
    description = "couchbase-epmd"
  }

  ingress {
    from_port   = 9100
    to_port     = 9105
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.bitesize.cidr_block}"]
    description = "couchbase-indexers"
  }

  ingress {
    from_port   = 9999
    to_port     = 9999
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.bitesize.cidr_block}"]
    description = "couchbase-indexer-projector"
  }

  ingress {
    from_port   = 21100
    to_port     = 21299
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.bitesize.cidr_block}"]
    description = "couchbase-data-exchange"
  }

  ingress {
    from_port   = 4369
    to_port     = 4369
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.bitesize.cidr_block}"]
    description = "couchbase-epmd"
  }

  # cassandra and couchbase
  ingress {
    from_port   = 11207
    to_port     = 11214
    protocol    = "tcp"
    cidr_blocks = ["${concat(list("${data.aws_vpc.bitesize.cidr_block}", "192.168.0.0/16"))}"]
    description = "cassandra"
  }

  # redis
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["${concat(list("${data.aws_vpc.bitesize.cidr_block}", "192.168.0.0/16"))}"]
    description = "redis"
  }

  # memcached and couchbase
  ingress {
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = ["${concat(list("${data.aws_vpc.bitesize.cidr_block}", "192.168.0.0/16"))}"]
    description = "memcached"
  }

  # elasticsearch
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${concat(list("${data.aws_vpc.bitesize.cidr_block}", "192.168.0.0/16"))}"]
    description = "elasticsearch"
  }

  # Outbound unfettered
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"

  tags = "${merge(var.default_tags, map(
    "Name", "${local.fullname}"
  ))}"
}

resource "aws_security_group" "lambda" {
  count             = "${var.create_dbs}"
  name        = "lambda-to-elasticsearch-${var.environment}-${var.environment_type}"
  description = "${var.prefix}-lambda_cleanup_to_elasticsearch"
  vpc_id = "${var.vpc_id}"

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  } 


  tags = "${merge(var.default_tags, map(
    "Name", "lambda-to-elasticsearch-${var.environment}-${var.environment_type}"
  ))}"
}


