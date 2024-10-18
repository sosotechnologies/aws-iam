resource "aws_efs_file_system" "this" {
  creation_token = "efs-${var.name}"
  lifecycle_policy {
    transition_to_ia                    = "AFTER_30_DAYS"
    # transition_to_primary_storage_class = "AFTER_1_ACCESS" ## comment out
  }

  encrypted = true # Enable encryption at rest
  
  # Optionally, specify a custom KMS key for encryption (if provided)
  kms_key_id = var.kms_key_id

  tags = merge(var.tags, {
    Name = "efs-${var.name}"
  })
}

resource "aws_efs_mount_target" "this" {
  count      = length(var.subnet_ids)
  file_system_id = aws_efs_file_system.this.id
  subnet_id  = var.subnet_ids[count.index]
  security_groups = [aws_security_group.efs.id]
}

### access point  ################
resource "aws_efs_access_point" "this" {
  count            = length(var.access_points)
  file_system_id   = aws_efs_file_system.this.id

  # Root directory settings for the access point
  posix_user {
    uid = var.access_points[count.index].uid
    gid = var.access_points[count.index].gid
  }

  root_directory {
    path = var.access_points[count.index].path

    creation_info {
      owner_uid   = var.access_points[count.index].owner_uid
      owner_gid   = var.access_points[count.index].owner_gid
      permissions = var.access_points[count.index].permissions
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name}-access-point-${count.index + 1}"
  })
}
################################################################

resource "aws_security_group" "efs" {
  name   = "${var.name}-efs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.96.0/19"] # Adjust to the actual allowed CIDR blocks
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
