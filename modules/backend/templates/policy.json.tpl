{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${bucket}",
      "Principal": {
        "AWS": [${operators}]
      }
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "${bucket}/${key}",
      "Principal": {
        "AWS": [${operators}]
      }
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "${bucket}/env:/*/${key}",
      "Principal": {
        "AWS": [${operators}]
      }
    }
  ]
}
