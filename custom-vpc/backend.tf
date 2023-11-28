terraform {
  backend "s3" {
    bucket = "tf-state-file-storage-26101997"
    region = "us-east-1"
    key = "tfstate_files-custom-vpc/terraform.tfstate"
  }
}