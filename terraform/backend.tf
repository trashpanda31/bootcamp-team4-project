terraform {
  backend "s3" {
    bucket       = "cloudsprint-team4"
    key          = "team4/aws/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
