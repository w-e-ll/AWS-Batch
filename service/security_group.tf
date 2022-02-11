resource "aws_security_group" "batch_sg" {
  name        = var.security_group_name
  description = "Trusted Security Group for trusted address"
  vpc_id      = module.vpc.vpi_id

  ingress {
    description = "Allow internal access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "BatchSG"
    Terraform = "True"
  }
}

