variable "prefix" {
  description = "Projcet name given as a prefix"
  type        = string
}
variable "vpc_cidr" {
  description = "The CIDR block of VPC"
  type        = string
}
variable "rds_password" {
  type = string
}
variable "rds_username" {
  type = string
}
