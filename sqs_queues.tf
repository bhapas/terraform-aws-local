resource "aws_sqs_queue" "awssqsqueueseidev" {
  name                      = "tf-sqs-queue-cloudtrail-sei.estc.dev"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.awssqsqueueseidev.arn
    maxReceiveCount     = 4
  })

  tags = {
    division   = "engineering"
    org        = "security"
    team       = "security-external-integrations"
    managed_by = "terraform"
  }

  policy = <<POLICY
{
    "Version": "2012-10-17"
    "Statement": [
        {
            "Sid": "ElasticSEIAWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
                "AWS": ${data.aws_caller_identity.current.account_id}
            },
            "Action": [
                "SQS:*"
            ],
            "Resource": "arn:aws:sqs::${data.aws_caller_identity.current.account_id}:${aws_sqs_queue.awssqsqueueseidev.name}"
        }
    ]
}
POLICY
}