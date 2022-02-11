data "aws_iam_policy_document" "events_batch" {
  statement {
    sid              = format("EventsBatch%s", var.job_tag)
    effect           = "Allow"
    actions          = ["batch:SubmitJob"]

    resources = [
      var.job_queue_arn,
      var.CV_job_arn,
    ]
  }
}

data "aws_iam_policy_document" "events_assume" {
  statement {
    sid              = format("EventsAssume%s", var.job_tag)
    effect           = "Allow"
    actions          = ["sts:AssumeRole"]

    principals {
      type           = "Service"
      identifiers    = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "service_role" {
  name               = format("%s_%s", var.event_policy_name, var.job_tag)
  description        = format("%s (%s)", var.event_policy_description, var.job_tag)
  path               = var.event_role_path
  policy             = data.aws_iam_policy_document.events_batch.json
}

resource "aws_iam_role" "service_role" {
  name               = format("%s_%s", var.event_role_name, var.job_tag)
  description        = format("%s (%s)", var.event_role_description, var.job_tag)
  path               = var.event_role_path
  assume_role_policy = data.aws_iam_policy_document.events_assume.*.json[0]
}

resource "aws_iam_role_policy_attachment" "service_role" {
  role               = aws_iam_role.service_role.name
  policy_arn         = aws_iam_policy.service_role.arn
}