/*
Module usage:
  module "dms_serverless" {
    source = "git::https://github.com/UKHomeOffice/acp-tf-dms-serverless?ref=main"

    environment = var.environment

    dms_replication_name               = "<ticket>-<tenant>-placeholder"
    dms_replication_type               = "full-load-and-cdc"
    dms_replication_max_capacity_units = "4"
    dms_replication_subnet_group_id    = <subnet_group_id>

    source_database            = "source_db"
    source_database_engine     = "engine"
    source_database_identifier = "<ticket>-<tenant>-source_db"
    source_database_username   = "root"
    source_database_password   = data.aws_kms_secrets.source_db.plaintext["password"]
    source_database_port       = "<port>"
    source_database_endpoint   = "<source_db_endpoint>"

    target_database            = "target_db"
    target_database_engine     = "engine"
    target_database_identifier = "<ticket>-<tenant>-target_db"
    target_database_username   = "root"
    target_database_password   = data.aws_kms_secrets.target_db.plaintext["password"]
    target_database_port       = "<port>"
    target_database_endpoint   = "<target_db_endpoint>"

    tags = {
      ...
    }
  }
*/


locals {
  email_tags = { for i, email in var.email_addresses : "email${i}" => email }
}

data "aws_caller_identity" "current" {

}

data "aws_region" "current" {

}

#KMS key used for DNS migration - this is configured for endpoints and dms instance/serverless
# DMS Serverless does not currently support the use of CMKs - Only the default AWS DMS Key
# https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Serverless.Limitations.html
# resource "aws_kms_key" "this" {
#   description         = "A kms key for DMS migrations"
#   enable_key_rotation = true
#   policy              = data.aws_iam_policy_document.kms_key_policy_document.json

#   tags = merge(
#     var.tags,
#     {
#       "Name" = format("%s-%s", var.environment, "${var.dms_replication_name}-dms")
#     },
#     {
#       "Env" = var.environment
#     },
#   )
# }

# resource "aws_kms_alias" "this" {
#   name          = "alias/${var.dms_replication_name}-dms"
#   target_key_id = aws_kms_key.this.key_id
# }

resource "aws_dms_endpoint" "source" {
  certificate_arn             = var.source_database_certificate_arn
  database_name               = var.source_database
  endpoint_id                 = var.source_database_identifier
  endpoint_type               = "source"
  engine_name                 = var.source_database_engine
  extra_connection_attributes = var.source_database_extra_connection_attributes
  # DMS Serverless does not currently support the use of CMKs - Only the default AWS DMS Key
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Serverless.Limitations.html
  # kms_key_arn                 = aws_kms_key.this.arn
  username    = var.source_database_username
  password    = var.source_database_password
  port        = var.source_database_port
  server_name = var.source_database_endpoint
  ssl_mode    = var.source_database_sslmode

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.source_database_identifier)
    },
    {
      "Env" = var.environment
    },
  )
}

resource "aws_dms_endpoint" "target" {
  certificate_arn             = var.target_database_certificate_arn
  database_name               = var.target_database
  endpoint_id                 = var.target_database_identifier
  endpoint_type               = "target"
  engine_name                 = var.target_database_engine
  extra_connection_attributes = var.target_database_extra_connection_attributes
  # DMS Serverless does not currently support the use of CMKs - Only the default AWS DMS Key
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Serverless.Limitations.html
  # kms_key_arn                 = aws_kms_key.this.arn
  username    = var.target_database_username
  password    = var.target_database_password
  port        = var.target_database_port
  server_name = var.target_database_endpoint
  ssl_mode    = var.target_database_sslmode

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.target_database_identifier)
    },
    {
      "Env" = var.environment
    },
  )
}

# Serverless DMS
resource "aws_dms_replication_config" "this" {
  replication_config_identifier = "${var.dms_replication_name}-dms"
  resource_identifier           = "${var.dms_replication_name}-dms"
  replication_type              = var.dms_replication_type
  source_endpoint_arn           = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn           = aws_dms_endpoint.target.endpoint_arn
  table_mappings                = var.dms_replication_table_mappings

  start_replication = true

  compute_config {
    replication_subnet_group_id  = var.dms_replication_subnet_group_id
    max_capacity_units           = var.dms_replication_max_capacity_units
    min_capacity_units           = "2"
    preferred_maintenance_window = var.dms_replication_preferred_maintenance_window
  }
}
