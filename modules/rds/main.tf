# Create db subnet group
resource "aws_db_subnet_group" "db_subnet" {
    subnet_ids                              = [ var.priv_sub_db_id[0], var.priv_sub_db_id[1] ]
    name                                    = "db_subnet_group"
}

# Create db instance
resource "aws_db_instance" "db_instance" {
    instance_class                          = var.instance_class
    allocated_storage                       = var.db_storage
    max_allocated_storage                   = var.db_max_storage
    storage_type                            = var.db_storage_type
    identifier                              = var.db_identifier
    engine                                  = var.engine
    engine_version                          = var.engine_version
    vpc_security_group_ids                  = [ var.db_sg ]
    username                                = var.db_username
    password                                = var.db_password
    db_subnet_group_name                    = aws_db_subnet_group.db_subnet.name
    backup_retention_period                 = 7  
    parameter_group_name                    = var.parameter_group_name
    final_snapshot_identifier               = var.final_ss_identifier 
    skip_final_snapshot                     = false
    multi_az                                = false
    allow_major_version_upgrade             = false
    apply_immediately                       = true 
    
    lifecycle {
        prevent_destroy                     = true
        ignore_changes                      = all
    }
}

# Create db instance replica
resource "aws_db_instance" "db_instance_replica" {
    instance_class                          = var.instance_class
    replicate_source_db                     = aws_db_instance.db_instance.arn  
    identifier                              = "${var.db_identifier}-replica"
    backup_retention_period                 = 0 
    engine                                  = var.engine
    engine_version                          = var.engine_version
    db_subnet_group_name                    = aws_db_subnet_group.db_subnet.name
    skip_final_snapshot                     = true

    lifecycle {
        prevent_destroy                     = true
        ignore_changes                      = all
    }
}