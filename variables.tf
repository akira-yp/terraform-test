variable "prefix" {
  description = "Projcet name given as a prefix"
  type        = string
  default     = "cloud02"
}

variable "vpc_cidr" {
  description = "The CIDR block of VPC"
  type        = string
  default     = "10.0.0.0/16"
}
