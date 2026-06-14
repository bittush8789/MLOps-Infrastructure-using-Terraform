variable "lock_table_name" {
  type    = string
  default = "mlops-tf-state-locks"
}

resource "aws_dynamodb_table" "locks" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Locking Table"
    Environment = "Global"
  }
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.locks.name
}
