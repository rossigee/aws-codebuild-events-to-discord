# AWS CodeBuild events to Discord

A Lambda-based handler for CodeBuild events that sends notification to a Discord channel.

* An SNS queue to send events to.
* An EventBridge rule to gather CodeBuild state change events and push them to the SNS queue.
* A Lambda function to handle the events, format them and send to Discord.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | 2.23.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.codebuild-events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_sns_topic.sns-topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.sns-topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional resource tags | `map(string)` | `{}` | no |
| <a name="input_discord_url"></a> [discord\_url](#input\_discord\_url) | Discord channel URL | `string` | n/a | yes |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | Name for SNS topic | `string` | `"aws-codebuild-events-to-discord"` | no |
| <a name="input_tracing_mode"></a> [tracing\_mode](#input\_tracing\_mode) | X-Ray tracing mode | `string` | `"None"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | ARN of Lambda function |
<!-- END_TF_DOCS -->