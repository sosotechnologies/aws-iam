## NOTE: It's going to use your AWS_REGION or AWS_DEFAULT_REGION environment variable,
## but you can define which on to use in terraform.tfvars file as well, or pass it as an argument
## in the CLI like this "terraform apply -var 'region=eu-west-1'"
variable "region" {
  description = "Region to deploy the resources"
  type        = string
}

# # ################################################################################
# # # AWS EFS CSI Driver
# # ################################################################################
variable "vpc_id" {
  description = "The VPC ID to associate with the EFS"
  type        = list(string)
  default     = [
    "vpc-05fe76c22b3059d48"
  ]
}

# Ensure you define subnet_ids variable in your variables.tf
variable "subnet_ids" {
  description = "List of subnet IDs where the EFS mount targets will be created"
  type        = list(string)
  default     = [
    "subnet-05330494f54f0da1c", # Subnet 1
    "subnet-09c9480163c55e6df", # Subnet 2
    "subnet-0d22c9dc956e5bc44"  # Subnet 3
  ]
}

# variable "tags" {
#   description = "A map of tags to add to all resources"
#   type        = map(string)
#   default     = {}
# }
# variable "name" {
#   description = "A unique name for the EFS"
#   type        = string
# }

# variable "vpc_id" {
#   description = "VPC ID where the EFS will be deployed"
#   type        = string
# }

# variable "subnet_ids" {
#   description = "Subnet IDs for EFS Mount Targets"
#   type        = list(string)
# }

# variable "security_group_ingress" {
#   description = "Ingress rules for the EFS security group"
#   type = map(object({
#     description = string
#     from_port   = number
#     protocol    = string
#     to_port     = number
#     self        = bool
#     cidr_blocks = list(string)
#   }))
# }

# variable "security_group_egress" {
#   description = "Egress rules for the EFS security group"
#   type = map(object({
#     description = string
#     from_port   = number
#     protocol    = string
#     to_port     = number
#     self        = bool
#     cidr_blocks = list(string)
#   }))
# }

# variable "performance_mode" {
#   description = "EFS performance mode"
#   type        = string
#   default     = "generalPurpose"
# }

# variable "encrypted" {
#   description = "Whether EFS is encrypted"
#   type        = bool
#   default     = true
# }

# variable "tags" {
#   description = "Tags to be applied to the resources"
#   type        = map(string)
# }
