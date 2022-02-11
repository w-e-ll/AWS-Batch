resource "aws_batch_compute_environment" "compute-environment" {
  compute_environment_name = var.ce_name
  service_role             = aws_iam_role.aws_batch_service_role.arn
  type                     = var.ce_management_type

  compute_resources {
    type                   = var.ce_type
    instance_type          = var.instance_type
    max_vcpus              = var.maxvcpus
    min_vcpus              = var.minvcpus
    desired_vcpus          = var.desired_vcpus
    security_group_ids     = var.ce_security_groups
    subnets                = var.ce_subnets
    instance_role          = aws_iam_instance_profile.ecs_instance_role.arn
    allocation_strategy    = var.ce_allocation_strategy

    dynamic "launch_template" {
      for_each             = var.ce_launch_template
      content {
        launch_template_id = launch_template.value.launch_template_id
        version            = try(launch_template.value.version, null)
      }
    }

  }
  depends_on               = [aws_iam_role_policy_attachment.aws_batch_service_role]

  lifecycle {
    create_before_destroy  = true
  }
}
