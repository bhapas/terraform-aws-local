resource "aws_cloudtrail" "awscloudtrailseidev" {
  name                          = "tf-cloudtrail-s3-sei.estc.dev"
  s3_bucket_name                = aws_s3_bucket.awss3bucketseidev.id
  s3_key_prefix                 = "cloudtrailkey"
  include_global_service_events = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }
}