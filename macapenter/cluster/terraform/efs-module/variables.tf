variable "name" {
  description = "The name of the EFS file system"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to associate with the EFS"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to create mount targets in"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

# Optional: If you want to use a custom KMS key for encryption
variable "kms_key_id" {
  description = "Optional KMS Key ID for encrypting the EFS. If not provided, the default AWS-managed key is used."
  type        = string
  default     = null
}

# Define access points with their configurations
variable "access_points" {
  description = "List of access points with their respective configurations"
  type = list(object({
    uid          = number  # UID of the POSIX user
    gid          = number  # GID of the POSIX group
    path         = string  # Path to use as the root directory
    owner_uid    = number  # Owner UID of the directory
    owner_gid    = number  # Owner GID of the directory
    permissions  = string  # Permissions for the directory
  }))
  default = []
}