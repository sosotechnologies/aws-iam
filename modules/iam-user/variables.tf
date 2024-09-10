variable "user_name" {
  description = "The name of the IAM user"
  type        = string
}

variable "pgp_key" {
  description = "The public GPG key used for encrypting the login profile password"
  type        = string
}
