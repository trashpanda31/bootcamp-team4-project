variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "ami_id" {
  type    = string
  default = "ami-027547022824dc6e0"
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "instance_profile_name" {
  type    = string
  default = "Bootcamp-Instance-Profile"
}

variable "ecr_repo_url" {
  type = string
}

variable "rds_secret_arn" {
  type = string
}

variable "app_container_port" {
  type    = number
  default = 80
}

variable "healthcheck_path" {
  type    = string
  default = "/"
}

variable "asg_min" {
  type    = number
  default = 1
}

variable "asg_desired" {
  type    = number
  default = 1
}

variable "asg_max" {
  type    = number
  default = 3
}

variable "instance_warmup" {
  type    = number
  default = 120
}

variable "min_healthy_percentage" {
  type    = number
  default = 90
}

variable "tags" {
  type = map(string)
  default = {
    Project = "CloudSprint-team4"
  }
}
