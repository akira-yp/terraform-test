resource "aws_db_instance" "rds" {
  allocated_storage   = 10
  db_name             = "mydb"
  engine              = "mysql"
  engine_version      = "8.0.30"
  license_model       = "general-public-license"
  identifier          = "${var.prefix}-db"
  instance_class      = "db.t3.micro"
  storage_type        = "gp2"
  username            = var.rds_username
  password            = var.rds_password
  port                = 3306
  publicly_accessible = false

  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db.id]

  tags = {
    Name = "${var.prefix}-rds"
  }
}

# subnet group
resource "aws_db_subnet_group" "db_subnets" {
  name = "${var.prefix}-db-subnet-g"

  subnet_ids = [
    aws_subnet.private_subnet_1c.id,
    aws_subnet.private_subnet_1a.id
  ]
  tags = {
    Name = "${var.prefix}-dev-db-subnet-g"
  }
}
