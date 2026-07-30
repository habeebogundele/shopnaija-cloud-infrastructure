terraform {
  backend "s3" {
    bucket  = "shopnaija-terraform-state-d1"
    key     = "shopnaija/assignment/terraform.tfstate"
    region  = "eu-north-1"
    encrypt = true
  }
}