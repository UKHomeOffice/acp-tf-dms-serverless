# acp-tf-dms-serverless terraform module

Module usage:
```
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
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.59.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.59.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dms_endpoint.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_endpoint) | resource |
| [aws_dms_endpoint.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_endpoint) | resource |
| [aws_dms_replication_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_config) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms_key_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dms_replication_max_capacity_units"></a> [dms\_replication\_max\_capacity\_units](#input\_dms\_replication\_max\_capacity\_units) | Specifies the maximum value of the DMS capacity units (DCUs) for which a given DMS Serverless replication can be provisioned. Please use one of: 2, 4, 8, 16, 32, 64, 128, 192, 256, 384 | `any` | n/a | yes |
| <a name="input_dms_replication_name"></a> [dms\_replication\_name](#input\_dms\_replication\_name) | The name of the DMS replciation - sugguested pattern - <ticket number>-<tenant> | `any` | n/a | yes |
| <a name="input_dms_replication_preferred_maintenance_window"></a> [dms\_replication\_preferred\_maintenance\_window](#input\_dms\_replication\_preferred\_maintenance\_window) | The preferred weekly time range during which system maintenance can occur, in Universal Coordinated Time (UTC), minimum 30 min block - format ddd:hh24:mi-ddd:hh24:mi  e.g. sun:23:45-mon:00:30 | `any` | `null` | no |
| <a name="input_dms_replication_subnet_group_id"></a> [dms\_replication\_subnet\_group\_id](#input\_dms\_replication\_subnet\_group\_id) | The ID of the DMS subnet group to use - must be routable to both source and target database endpoint | `any` | n/a | yes |
| <a name="input_dms_replication_table_mappings"></a> [dms\_replication\_table\_mappings](#input\_dms\_replication\_table\_mappings) | json escaped string of table mappings - default is % wildcard for schemas and tables | `string` | `"{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"rule-action\":\"include\",\"object-locator\":{\"schema-name\":\"%%\",\"table-name\":\"%%\"}}]}"` | no |
| <a name="input_dms_replication_type"></a> [dms\_replication\_type](#input\_dms\_replication\_type) | The type of DMS replication, please use one of: full-load, cdc, full-load-and-cdc | `any` | n/a | yes |
| <a name="input_email_addresses"></a> [email\_addresses](#input\_email\_addresses) | A list of email addresses for key rotation notifications. | `list` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment DMS is running in i.e. dev, prod etc | `any` | n/a | yes |
| <a name="input_source_database"></a> [source\_database](#input\_source\_database) | The name of the database that needs to be migrated | `any` | n/a | yes |
| <a name="input_source_database_certificate_arn"></a> [source\_database\_certificate\_arn](#input\_source\_database\_certificate\_arn) | The ARN of an ACM certificate should one be needed | `any` | `null` | no |
| <a name="input_source_database_endpoint"></a> [source\_database\_endpoint](#input\_source\_database\_endpoint) | The endpoint of the source database | `any` | n/a | yes |
| <a name="input_source_database_engine"></a> [source\_database\_engine](#input\_source\_database\_engine) | The source database engine, please pick one of: aurora, aurora-postgresql, azuredb, azure-sql-managed-instance, babelfish, db2, db2-zos, docdb, dynamodb, elasticsearch, kafka, kinesis, mariadb, mongodb, mysql, opensearch, oracle, postgres, redshift, s3, sqlserver, sybase | `any` | n/a | yes |
| <a name="input_source_database_extra_connection_attributes"></a> [source\_database\_extra\_connection\_attributes](#input\_source\_database\_extra\_connection\_attributes) | Any additional connection attributes needed to connect to the source database. Please see https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.html for more info | `any` | `null` | no |
| <a name="input_source_database_identifier"></a> [source\_database\_identifier](#input\_source\_database\_identifier) | The name of the the source database endpoint on DMS - sugguested pattern - <ticket number>-<tenant>-<source database name> | `any` | n/a | yes |
| <a name="input_source_database_password"></a> [source\_database\_password](#input\_source\_database\_password) | The password for the username of the source database | `any` | n/a | yes |
| <a name="input_source_database_port"></a> [source\_database\_port](#input\_source\_database\_port) | The port of the source database. E.g. mysql - 3306, postgres - 5432 | `any` | n/a | yes |
| <a name="input_source_database_sslmode"></a> [source\_database\_sslmode](#input\_source\_database\_sslmode) | The SSL mode used to connect to the database. Pick one of: none, require, verify-ca, verify-full | `string` | `"require"` | no |
| <a name="input_source_database_username"></a> [source\_database\_username](#input\_source\_database\_username) | The username of the source database to use - usually root, a user needs to have the neccessary permissions for DMS | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map` | `{}` | no |
| <a name="input_target_database"></a> [target\_database](#input\_target\_database) | The name of the database on the target | `any` | n/a | yes |
| <a name="input_target_database_certificate_arn"></a> [target\_database\_certificate\_arn](#input\_target\_database\_certificate\_arn) | The ARN of an ACM certificate should one be needed | `any` | `null` | no |
| <a name="input_target_database_endpoint"></a> [target\_database\_endpoint](#input\_target\_database\_endpoint) | The endpoint of the target database | `any` | n/a | yes |
| <a name="input_target_database_engine"></a> [target\_database\_engine](#input\_target\_database\_engine) | The target database engine, please pick one of: aurora, aurora-postgresql, azuredb, azure-sql-managed-instance, babelfish, db2, db2-zos, docdb, dynamodb, elasticsearch, kafka, kinesis, mariadb, mongodb, mysql, opensearch, oracle, postgres, redshift, s3, sqlserver, sybase | `any` | n/a | yes |
| <a name="input_target_database_extra_connection_attributes"></a> [target\_database\_extra\_connection\_attributes](#input\_target\_database\_extra\_connection\_attributes) | Any additional connection attributes needed to connect to the target database. Please see https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.html for more info | `any` | `null` | no |
| <a name="input_target_database_identifier"></a> [target\_database\_identifier](#input\_target\_database\_identifier) | The name of the the target database endpoint on DMS - sugguested pattern - <ticket number>-<tenant>-<source database name> | `any` | n/a | yes |
| <a name="input_target_database_password"></a> [target\_database\_password](#input\_target\_database\_password) | The password for the username of the target database | `any` | n/a | yes |
| <a name="input_target_database_port"></a> [target\_database\_port](#input\_target\_database\_port) | The port of the target database. E.g. mysql - 3306, postgres - 5432 | `any` | n/a | yes |
| <a name="input_target_database_sslmode"></a> [target\_database\_sslmode](#input\_target\_database\_sslmode) | The SSL mode used to connect to the database. Pick one of: none, require, verify-ca, verify-full | `string` | `"require"` | no |
| <a name="input_target_database_username"></a> [target\_database\_username](#input\_target\_database\_username) | The username of the target database to use - usually root, a user needs to have the neccessary permissions for DMS | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->