variable "email_addresses" {
  description = "A list of email addresses for key rotation notifications."
  default     = []
}

variable "environment" {
  description = "The environment DMS is running in i.e. dev, prod etc"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

# DMS Config

variable "dms_replication_name" {
  description = "The name of the DMS replciation - sugguested pattern - <ticket number>-<tenant>"
}

variable "dms_replication_type" {
  description = "The type of DMS replication, please use one of: full-load, cdc, full-load-and-cdc"
}

variable "dms_replication_table_mappings" {
  description = "json escaped string of table mappings - default is % wildcard for schemas and tables"
  default     = "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"rule-action\":\"include\",\"object-locator\":{\"schema-name\":\"%%\",\"table-name\":\"%%\"}}]}"
}

variable "dms_replication_max_capacity_units" {
  description = "Specifies the maximum value of the DMS capacity units (DCUs) for which a given DMS Serverless replication can be provisioned. Please use one of: 2, 4, 8, 16, 32, 64, 128, 192, 256, 384"
}

variable "dms_replication_preferred_maintenance_window" {
  description = "The preferred weekly time range during which system maintenance can occur, in Universal Coordinated Time (UTC), minimum 30 min block - format ddd:hh24:mi-ddd:hh24:mi  e.g. sun:23:45-mon:00:30"
  default     = null
}

variable "dms_replication_subnet_group_id" {
  description = "The ID of the DMS subnet group to use - must be routable to both source and target database endpoint"
}

# DMS Source
variable "source_database_certificate_arn" {
  description = "The ARN of an ACM certificate should one be needed"
  default     = null
}

variable "source_database" {
  description = "The name of the database that needs to be migrated"
}

variable "source_database_engine" {
  description = "The source database engine, please pick one of: aurora, aurora-postgresql, azuredb, azure-sql-managed-instance, babelfish, db2, db2-zos, docdb, dynamodb, elasticsearch, kafka, kinesis, mariadb, mongodb, mysql, opensearch, oracle, postgres, redshift, s3, sqlserver, sybase"
}

variable "source_database_identifier" {
  description = "The name of the the source database endpoint on DMS - sugguested pattern - <ticket number>-<tenant>-<source database name>"
}

variable "source_database_extra_connection_attributes" {
  description = "Any additional connection attributes needed to connect to the source database. Please see https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.html for more info"
  default     = null
}

variable "source_database_username" {
  description = "The username of the source database to use - usually root, a user needs to have the neccessary permissions for DMS"
}

variable "source_database_password" {
  description = "The password for the username of the source database"
}

variable "source_database_port" {
  description = "The port of the source database. E.g. mysql - 3306, postgres - 5432"
}

variable "source_database_endpoint" {
  description = "The endpoint of the source database"
}

variable "source_database_sslmode" {
  description = "The SSL mode used to connect to the database. Pick one of: none, require, verify-ca, verify-full"
  default     = "require"
}

# DMS Target
variable "target_database_certificate_arn" {
  description = "The ARN of an ACM certificate should one be needed"
  default     = null
}

variable "target_database" {
  description = "The name of the database on the target"
}

variable "target_database_engine" {
  description = "The target database engine, please pick one of: aurora, aurora-postgresql, azuredb, azure-sql-managed-instance, babelfish, db2, db2-zos, docdb, dynamodb, elasticsearch, kafka, kinesis, mariadb, mongodb, mysql, opensearch, oracle, postgres, redshift, s3, sqlserver, sybase"
}

variable "target_database_identifier" {
  description = "The name of the the target database endpoint on DMS - sugguested pattern - <ticket number>-<tenant>-<source database name>"
}

variable "target_database_extra_connection_attributes" {
  description = "Any additional connection attributes needed to connect to the target database. Please see https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.html for more info"
  default     = null
}

variable "target_database_username" {
  description = "The username of the target database to use - usually root, a user needs to have the neccessary permissions for DMS"
}

variable "target_database_password" {
  description = "The password for the username of the target database"
}

variable "target_database_port" {
  description = "The port of the target database. E.g. mysql - 3306, postgres - 5432"
}

variable "target_database_endpoint" {
  description = "The endpoint of the target database"
}

variable "target_database_sslmode" {
  description = "The SSL mode used to connect to the database. Pick one of: none, require, verify-ca, verify-full"
  default     = "require"
}
