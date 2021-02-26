output "rds-url" {
  value     = aws_db_instance.rds_instance[0].address
  sensitive = true
  depends_on = [
    aws_db_instance.rds_instance[0]
  ]
}