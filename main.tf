provider "aws" {
  region 	= "us-east-1"
  /*shared_config_files = ["%USERPROFILE%/.aws/config"]
  profile = "{{NAME-OF-THE-MNG-PROFILE}}"*/
}

terraform {
  backend "s3" {
    bucket = "253490770282-aftbootstrap-tfstate"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "ddb-aftbootstrap-state"
  }
}

module "aft_pipeline" {
  source = "github.com/aws-ia/terraform-aws-control_tower_account_factory"
  # Required Variables
  ct_management_account_id                         = "253490770282"
  log_archive_account_id                           = "072950892279"
  audit_account_id                                 = "553410889852"
  aft_management_account_id                        = "747143892720"
  ct_home_region                                   = "us-east-1"
  /*tf_backend_secondary_region                      = "af-south-1"*/
  
  # Terraform variables
  terraform_version                                = "1.6.0"
  terraform_distribution                           = "oss"
    
  # VCS Vars
  vcs_provider                                     = "github"
  account_request_repo_name                        = "saidreddym/aft-account-request"
  global_customizations_repo_name                  = "saidreddym/aft-global-customizations"
  account_customizations_repo_name                 = "saidreddym/aft-account-customizations"
  account_provisioning_customizations_repo_name    = "saidreddym/aft-account-provisioning-customizations"

  # AFT Feature flags
  aft_feature_cloudtrail_data_events               = false
  aft_feature_enterprise_support                   = false
  aft_feature_delete_default_vpcs_enabled          = true

  # AFT Additional Configurations
  aft_enable_vpc                                   = false
  backup_recovery_point_retention                  = 1
  log_archive_bucket_object_expiration_days        = 1
}