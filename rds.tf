variable "rds_password" {
  type = string
}
variable "rds_username" {
  type = string
}

resource "aws_db_instance" "rds" {
  allocated_storage   = 10
  db_name             = "mydb"
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  username            = var.rds_username
  password            = var.rds_password
  skip_final_snapshot = true
}
