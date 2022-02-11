data "aws_ami" "ecs_ami" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = [var.ecs_ami_name]
  }
}

resource "aws_launch_template" "launch_template" {
  name_prefix            = "${var.ce_name}-${var.environment}"
  vpc_security_group_ids = [var.ecs_service_sg_id]
  image_id               = data.aws_ami.ecs_ami.id
  instance_type          = var.instance_type
//  user_data              = base64encode(var.user_data)
  tags = {
    for tag in local.tags :
    tag.name => tag.value
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 90
    }
  }

  ebs_optimized = true

  update_default_version = true

  iam_instance_profile {
    name = var.ecs_instance_role_name
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      for tag in local.tags :
      tag.name => tag.value
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      for tag in local.tags :
      tag.name => tag.value
    }
  }
}