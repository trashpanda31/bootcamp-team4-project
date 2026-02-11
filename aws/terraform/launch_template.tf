locals {
  ecr_registry = split("/", var.ecr_repo_url)[0]
}

resource "aws_launch_template" "team4_lt" {
  name_prefix   = "CloudSprint-team4-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  monitoring {
    enabled = true
  }

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  user_data = base64encode("#!/bin/bash\necho boot\n")

  update_default_version = true

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = "CloudSprint-team4-asg" })
  }

  tags = merge(var.tags, { Name = "CloudSprint-team4-lt" })
}
