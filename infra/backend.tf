terraform {
  backend "s3" {
    bucket         = "github-actions-terraform-dynamodb-streams-lambda"
    key            = "terraform-dynamodb-lambda-streams/dev/infra.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks" # create once for state locking
    encrypt        = true
  }
}
