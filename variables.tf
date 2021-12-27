variable "discord_url" {
  description = "Discord channel URL"
  type        = string
}

variable "sns_topic_name" {
  description = "Name for SNS topic"
  type        = string
  default     = "aws-codebuild-events-to-discord"
}

variable "additional_tags" {
  description = "Additional resource tags"
  type        = map(string)
  default     = {}
}
