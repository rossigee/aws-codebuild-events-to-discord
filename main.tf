resource "aws_sns_topic" "sns-topic" {
  name = var.sns_topic_name

  tags = var.additional_tags
}

resource "aws_sns_topic_subscription" "sns-topic" {
  topic_arn = aws_sns_topic.sns-topic.arn
  protocol  = "lambda"
  endpoint  = module.lambda.lambda_function_arn
}

module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "2.23.0"

  function_name = "aws-codebuild-events-to-discord"
  description   = "Sends CodeBuild event notifications to Discord."
  handler       = "handler.lambda_handler"
  runtime       = "python3.9"
  timeout       = 15
  source_path   = "src"

  environment_variables = {
    "DISCORD_URL" = var.discord_url
  }

  allowed_triggers = {
    "sns" = {
      principal  = "sns.amazonaws.com"
      source_arn = aws_sns_topic.sns-topic.arn
    }
  }

  cloudwatch_logs_retention_in_days = 90

  publish = true

  tags = var.additional_tags
}

resource "aws_cloudwatch_event_rule" "codebuild-events" {
  name        = "aws-codebuild-events-to-discord"
  description = "Forward CodeBuild events to Discord via SNS topic and Lambda function"

  event_pattern = <<EOF
{
  "source": [
    "aws.codebuild"
  ],
  "detail-type": [
    "CodeBuild Build State Change"
  ],
  "detail": {
    "build-status": [
      "IN_PROGRESS",
      "SUCCEEDED",
      "FAILED",
      "STOPPED"
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.codebuild-events.name
  target_id = "SendToDiscord"
  arn       = aws_sns_topic.sns-topic.arn
}
