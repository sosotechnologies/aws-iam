variable "name" {
  description = "The name of the EFS file system"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to associate with the EFS"
  type        = string
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

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

# # Define access points with their configurations
# variable "access_points" {
#   description = "List of access points with their respective configurations"
#   type = list(object({
#     uid          = number  # UID of the POSIX user
#     gid          = number  # GID of the POSIX group
#     path         = string  # Path to use as the root directory
#     owner_uid    = number  # Owner UID of the directory
#     owner_gid    = number  # Owner GID of the directory
#     permissions  = string  # Permissions for the directory
#   }))
#   default = []
# }

variable "encrypted" {
  description = "If true, the file system will be encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "If set, use a specific KMS key"
  type        = string
  default     = null
}

variable "lifecycle_policy" {
  description = "Lifecycle Policy for the EFS Filesystem"
  type = list(object({
    transition_to_ia = string
  }))
  default = []
}

variable "performance_mode" {
  description = "The file system performance mode."
  type        = string
  default     = null
}

variable "throughput_mode" {
  description = "Throughput mode for the file system."
  type        = string
  default     = null
}

variable "provisioned_throughput_in_mibps" {
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned."
  type        = string
  default     = null
}

# variable "backup_policy_status" {
#   description = "Enable/disable backup for EFS Filesystem.  Value should be ENABLE/DISABLED.  Defaults to DISABLED"
#   type        = string
#   default     = "DISABLED"
#   validation {
#     condition     = var.backup_policy_status == "ENABLED" || var.backup_policy_status == "DISABLED"
#     error_message = "Sorry, value must be either 'ENABLED' or 'DISABLED'."
#   }
# }