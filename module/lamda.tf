resource "aws_iam_policy" "lambda_policy" {
  name        = "${local.globalname}-es-indices-cleanup"
  path        = "/"
  description = "Policy for ${var.prefix}es-cleanup Lambda function"
  policy      = "${data.aws_iam_policy_document.es-indices-cleanup.json}"

}

resource "aws_iam_role" "lambda_role" {
  name        = "${local.globalname}-es-indices-cleanup"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = "${aws_iam_role.lambda_role.name}"
  policy_arn = "${aws_iam_policy.lambda_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment_vpc" {
  count      = "${var.create_dbs}"
  role       = "${aws_iam_role.lambda_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}



####### zip file for lambda ####
data "archive_file" "es_cleanup_lambda" {
  type        = "zip"
  source_file = "${path.module}/files/es-cleanup.py"
  output_path = "${path.module}/files/es-cleanup.zip"

}

resource "aws_lambda_function" "es_cleanup_vpc" {
  count            = "${var.create_dbs}"
  filename         = "${path.module}/files/es-cleanup.zip"
  function_name    = "${local.globalname}-es-indices-cleanup"
  description      = "${var.prefix}-es-cleanup"
  timeout          = 300
  runtime          = "python${var.python_version}"
  role             = "${aws_iam_role.lambda_role.arn}"
  handler          = "es-cleanup.lambda_handler"
  source_code_hash = "${data.archive_file.es_cleanup_lambda.output_base64sha256}"

  environment {
    variables = {
      es_endpoint  = "${aws_elasticsearch_domain.es.endpoint}"
      index        = "${var.index}"
      es_delete_after = "${var.es_delete_after}"
      index_format = "${var.index_format}"
      sns_alert    = "${var.sns_alert}"
    }
  }

  tags = "${merge(var.default_tags,map(
    "Name", "${local.globalname}-es-indices-cleanup",
    "Domain", "${local.globalname}-es-indices-cleanup"
            ))}"


  vpc_config {
    subnet_ids         = ["${var.db_subnet_ids[0]}", "${var.db_subnet_ids[1]}"]
    security_group_ids = ["${aws_security_group.lambda.id}"]


  }
}

##Cloudwatch event schedule and rules for the lambda function
resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "${var.environment}-${var.environment_type}-es-cleanup-execution-schedule"
  description         = "${var.environment}-${var.environment_type}-es-cleanup-execution-schedule"
  schedule_expression = "${var.schedule}"
}

resource "aws_cloudwatch_event_target" "es_cleanup_vpc" {
  count     = "${var.create_dbs}"
  target_id = "lambda-es-cleanup"
  rule      = "${aws_cloudwatch_event_rule.schedule.name}"
  arn       = "${aws_lambda_function.es_cleanup_vpc.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_vpc" {
  count         = "${length(var.db_subnet_ids) > 0 ? 1 : 0}"
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.es_cleanup_vpc.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.schedule.arn}"
}



