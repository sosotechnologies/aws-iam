resource "aws_efs_file_system" "mimeo" {
  creation_token = "efs-${var.name}"
  dynamic "lifecycle_policy" {
    for_each = var.lifecycle_policy
    content {
      transition_to_ia = lookup(lifecycle_policy.value, "transition_to_ia", null)
    }
  }
  performance_mode                = var.performance_mode
  throughput_mode                 = var.throughput_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  encrypted                       = var.encrypted  
  kms_key_id                      = var.kms_key_id  

  tags = merge(var.tags, {
    Name = "efs-${var.name}"
  })
}

resource "aws_efs_mount_target" "mimeo" {
  count          = length(var.subnet_ids) # Ensure this matches the number of subnets for your EKS cluster
  file_system_id = aws_efs_file_system.mimeo.id
  subnet_id      = var.subnet_ids[count.index] # Ensure this variable holds the correct subnet IDs
  security_groups = [aws_security_group.efs.id]
}

# Security Group for EFS
resource "aws_security_group" "efs" {
  name   = "${var.name}-efs-sg"
  vpc_id = var.vpc_id # Make sure this points to the correct VPC ID where your EKS cluster resides

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.96.0/19"] # Adjust this to your actual allowed CIDR blocks or subnets
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-efs-sg"
  })
}

# ### access point  ################
# resource "aws_efs_access_point" "mimeo" {
#   count            = length(var.access_points)
#   file_system_id   = aws_efs_file_system.mimeo.id

#   # Root directory settings for the access point
#   posix_user {
#     uid = var.access_points[count.index].uid
#     gid = var.access_points[count.index].gid
#   }

#   root_directory {
#     path = var.access_points[count.index].path

#     creation_info {
#       owner_uid   = var.access_points[count.index].owner_uid
#       owner_gid   = var.access_points[count.index].owner_gid
#       permissions = var.access_points[count.index].permissions
#     }
#   }

#   tags = merge(var.tags, {
#     Name = "${var.name}-access-point-${count.index + 1}"
#   })
# }
################################################################

# resource "aws_efs_backup_policy" "mimeo" {
#   file_system_id = aws_efs_file_system.mimeo.id

#   backup_policy {
#     status = var.backup_policy_status
#   }
# }