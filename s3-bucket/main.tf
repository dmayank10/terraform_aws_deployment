provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "tf-state-storage" {
  bucket = "tf-state-file-storage-26101997"
  force_destroy = true
}