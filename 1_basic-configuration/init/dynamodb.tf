resource "aws_dynamodb_table" "terraform" {
  count          = length(var.dynamodb_tables)
  name           = var.dynamodb_tables[count.index]
  provider       = aws.default
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name         = "LockID"
    type         = "S"
  }
  tags           = tomap({name = var.dynamodb_tables[count.index],
                          type = "database"})

}