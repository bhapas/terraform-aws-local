resource "aws_s3_bucket" "awss3bucketseidev" {
  bucket        = "tf-s3-bucket-cloudtrail-sei.estc.dev"
  force_destroy = true
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
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::tf-se-bucket-cpoqs"
        },
        {
            "Sid": "ElasticSEIAWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::tf-s3-bucket-cloudtrail-sei.estc.dev/cloudtrailkey/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}