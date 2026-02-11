variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "vpc_id" {
  description = "Bootcamp shared VPC"
  type        = string
}

variable "vpc_id" {}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}
