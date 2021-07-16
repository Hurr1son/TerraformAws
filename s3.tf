resource "aws_s3_bucket" "chisto_state" {
    bucket = "chisto-state"

    lifecycle {
        prevent_destroy = true
       }

    versioning {
        enabled = true
    }
    
       server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
            }
        }
    }
}
resource "aws_dynamodb_table" "terraform_locks" {
    name = "chisto-state"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    
    attribute {
        name = "LockID"
        type = "S"
    }
}

terraform {
    backend "s3" {
        bucket = "chisto-state"
        key = "s3/terraform.tfstate"
        region = "us-east-2"
        
        dynamodb_table = "chisto-state"
        encrypt = true
    }
}
