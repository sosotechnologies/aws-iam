output "efs_id" {
  description = "The ID of the EFS file system"
  value       = aws_efs_file_system.this.id
}

output "efs_security_group_id" {
  description = "The security group ID associated with EFS"
  value       = aws_security_group.efs.id
}

# Output the access points' IDs
output "efs_access_point_ids" {
  description = "The IDs of the EFS access points"
  value       = [for ap in aws_efs_access_point.this : ap.id]
}