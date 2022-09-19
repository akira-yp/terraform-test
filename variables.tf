variable "prefix" {
  description = "Projcet name given as a prefix"
  type        = string
  default     = "tf-test"
}
variable "vpc_cidr" {
  description = "The CIDR block of VPC"
  type        = string
  default     = "172.26.0.0/16"
}
variable "rds_password" {
  type = string
}
variable "rds_username" {
  type = string
}
