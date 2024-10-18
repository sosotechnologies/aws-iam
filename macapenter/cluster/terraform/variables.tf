## NOTE: It's going to use your AWS_REGION or AWS_DEFAULT_REGION environment variable,
## but you can define which on to use in terraform.tfvars file as well, or pass it as an argument
## in the CLI like this "terraform apply -var 'region=eu-west-1'"
variable "region" {
  description = "Region to deploy the resources"
  type        = string
}

# ################################################################################
# # AWS EFS CSI Driver
# ################################################################################

# variable "enable_aws_efs_csi_driver" {
#   description = "Enable AWS EFS CSI Driver add-on"
#   type        = bool
#   default     = false
# }

# variable "aws_efs_csi_driver" {
#   description = "EFS CSI Driver add-on configuration values"
#   type        = any
#   default     = {}
# }