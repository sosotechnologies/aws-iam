output "efs_id" {
  description = "The ID of the EFS file system"
  value       = aws_efs_file_system.mimeo.id
}

output "efs_security_group_id" {
  description = "The security group ID associated with EFS"
  value       = aws_security_group.efs.id
}

# # Output the access points' IDs
# output "efs_access_point_ids" {
#   description = "The IDs of the EFS access points"
#   value       = [for ap in aws_efs_access_point.this : ap.id]
# }

# # EFS File System ID
# output "efs_file_system_id" {
#   description = "EFS File System ID"
#   value = aws_efs_file_system.efs_file_system.id 
# }

# output "efs_file_system_dns_name" {
#   description = "EFS File System DNS Name"
#   value = aws_efs_file_system.efs_file_system.dns_name
# }


# # EFS Mounts Info
# output "efs_mount_target_id" {
#   description = "EFS File System Mount Target ID"
#   value = aws_efs_mount_target.efs_mount_target[*].id 
# }

# output "efs_mount_target_dns_name" {
#   description = "EFS File System Mount Target DNS Name"
#   value = aws_efs_mount_target.efs_mount_target[*].mount_target_dns_name 
# }

# output "efs_mount_target_availability_zone_name" {
#   description = "EFS File System Mount Target availability_zone_name"
#   value = aws_efs_mount_target.efs_mount_target[*].availability_zone_name 
# }
