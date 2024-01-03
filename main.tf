data "aws_iam_policy_document" "default" {
  statement {
    sid = ""
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}
resource "aws_iam_role" "iam" {
  name                 = local.iam_name
  path                 = "/"
  assume_role_policy   = data.aws_iam_policy_document.default.json
  #permissions_boundary = var.permissions_boundary_arn
  tags                 = var.ec2_tags
}

resource "aws_iam_instance_profile" "test_profile" {
  name = var.instance_profile_name
  role = "${aws_iam_role.iam.name}"
}

data "aws_subnet" "test" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.Subnet_Name
  }
}



module "new_security_group" {
  source = "./modules/security_group_new"
  security_rules = local.security_rules  
  vpc_id = var.vpc_id
}


# data "aws_instance" "foo" {
#   count = var.aws_ec2_instance == false ? 1 : 0
#   filter {
#     name   = "tag:Name"
#     values = ["SSB-LPX-001-P"]
#   }
# }

# module "existing_sg_rules" {
#   source = "./modules/existing_sg_rules"
#   existing_sg_rules = local.existing_sg_rules
# }


resource "aws_instance" "project-iac-ec2-linux" {
  ami                                  = var.ami_id
  availability_zone                    = var.availability_zone
  instance_type                        = var.instance_type
  disable_api_termination              = false
  associate_public_ip_address 		     = var.associate_public_ip_address
  iam_instance_profile                 = aws_iam_instance_profile.test_profile.name
  key_name                             = var.key_name
  subnet_id                            = data.aws_subnet.test.id
  monitoring                           = var.monitoring
  private_ip                           = var.private_ip
  vpc_security_group_ids               = concat(module.new_security_group.id[*],var.security_group_ids[*])
  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    iops                  = local.root_iops
    throughput            = local.root_throughput 
    delete_on_termination = false
    encrypted             = true
    #kms_key_id            = var.root_block_device_kms_key_id
  }
depends_on = [module.new_security_group.rds_security_groups, aws_iam_role.iam]
tags = merge(tomap(var.ec2_tags),
{ApplicationFunctionality = var.ApplicationFunctionality, 
ApplicationDescription= var.ApplicationDescription,
ApplicationOwner = var.ApplicationOwner, 
ApplicationTeam = var.ApplicationTeam, 
BackupSchedule =var.BackupSchedule,
BusinessOwner = var.BusinessOwner,
ServiceCriticality =var.ServiceCriticality,
Subnet-Name = var.Subnet_Name,
VPC-id = var.vpc_id
})

lifecycle {
     ignore_changes = [ami]
     }
}

resource "aws_eip_association" "eip_assoc" {
  count       = strcontains(var.Subnet_Name, "public") ? 1: 0
  instance_id   = aws_instance.project-iac-ec2-linux.id
  allocation_id = var.eip_allocation_id
}


module "ebs_volume" {
    source = "./modules/ebs_volume"
    
    ebs_volumes = var.ebs_volume_count
    azs =   var.availability_zone
    size= var.size
    ebs_device_name = var.ebs_device_name
    snapshot_id       = var.snapshot_id  ## To be set if Volume to be created from Snapshot
    efs_tags = var.efs_tags
    instance_id = aws_instance.project-iac-ec2-linux.id
    # ... omitted
  }


resource "aws_cloudwatch_metric_alarm" "reboot-alarm" {
  alarm_name                = "RebootAlarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        =  var.reboot_evaluation_period
  metric_name               =  var.reboot_metric_name
  namespace                 = "AWS/EC2"
  period                    =  var.reboot_period
  statistic                 =  var.reboot_statistic_period
  threshold                 =  var.reboot_metric_threshold
  alarm_description         = "Trigger a reboot action when instance satus check fails for 15 consecutive minutes"
  actions_enabled           = "true"
  # alarm_actions             = var.reboot_actions_alarm
  # ok_actions                = var.reboot_actions_ok
  alarm_actions             = var.reboot_actions_alarm
  ok_actions                = local.reboot_actions_ok
    dimensions = {
        InstanceId = aws_instance.project-iac-ec2-linux.id
      }
  }
resource "aws_cloudwatch_metric_alarm" "recover-alarm" {
  alarm_name                = "RecoverAlarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        =  var.recover_evaluation_period
  metric_name               =  var.recover_metric_name
  namespace                 = "AWS/EC2"
  period                    =  var.recover_period
  statistic                 =  var.recover_statistic_period
  threshold                 =  var.recover_metric_threshold
  alarm_description         = "Trigger a recover action when instance status check fails for 15 consecutive minutes"
  actions_enabled           = "true"
  alarm_actions             = var.recover_actions_alarm
  ok_actions                = local.recover_actions_ok
    dimensions = {
        InstanceId = aws_instance.project-iac-ec2-linux.id
      }
  }