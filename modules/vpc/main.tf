variable "get_vpc" {
  description = "Flag to get vpc, subnet ids"
  type        = bool
  default     = true
}

data "aws_iam_account_alias" "current" {}

data "aws_vpc" "current_vpc" {
  count = var.get_vpc ? 1 : 0
  filter {
      name   = "tag:Name"
      values = [data.aws_iam_account_alias.current.account_alias]
  }
}

data "aws_subnet_ids" "public_subnets" {
  count = var.get_vpc ? 1 : 0
  vpc_id = data.aws_vpc.current_vpc[0].id

  filter {
      name = "tag:SUB-Type"
      values = ["Public"]
  }
}

data "aws_subnet_ids" "private_subnets" {
  count = var.get_vpc ? 1 : 0
  vpc_id = data.aws_vpc.current_vpc[0].id

  filter {
      name = "tag:SUB-Type"
      values = ["Private"]
  }
}
