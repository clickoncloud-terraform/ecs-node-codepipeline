terraform {
  backend "s3" {
    bucket = "soumen-terraform-s3-bucket"
    key    = "ecs-terraform.state"
    region = "us-east-1"
    //dynamodb_table = "terraform_state"  
  }
}