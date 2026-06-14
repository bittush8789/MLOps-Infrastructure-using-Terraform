data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"

  source {
    content  = <<-EOT
def handler(event, context):
    print("Executing MLOps Lambda trigger...")
    return {
        'statusCode': 200,
        'body': 'Successfully triggered MLOps endpoint!'
    }
    EOT
    filename = "index.py"
  }
}

resource "aws_lambda_function" "this" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.function_name}-${var.environment}"
  role             = var.role_arn
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = var.environment_variables
  }

  tags = merge(
    {
      Name        = "${var.function_name}-${var.environment}"
      Environment = var.environment
    },
    var.tags
  )
}
