locals {
  # volume_count   		     = var.ebs_volume_count
  root_volume_type       = var.root_volume_type
  root_iops              = contains(["io1", "io2", "gp3"], var.root_volume_type) ? var.root_iops : null
  root_throughput        = var.root_volume_type == "gp3" ? var.root_throughput : null
  reboot_actions_ok   =  ["arn:aws:sns:${var.region}:${var.ACCTID}:Ec2RebootRecover"]
  recover_actions_ok  =  ["arn:aws:sns:${var.region}:${var.ACCTID}:Ec2RebootRecover"]
  iam_name  =  join("_", [lookup(var.ec2_tags , "Name"), "IaM_Role"])
    ##List the New Security Groups to be created and the Ingress rules for each. Naming Convention for
  #Security Groups  SG_{EC2_Instance_Name}_{Unique Number or Name}
  security_rules = {
  join("-", ["SG", lookup(var.ec2_tags , "Name"), "InstanceSecurityGroup", "1"]) = {
    "rule1" = { type = "ingress", from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "For SSH" },
    "rule2" = { type = "ingress", from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["10.10.0.18"], description = "For SSH" },
    "rule3" = { type = "egress", from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["10.0.0.19"], description = "For SSH" }
  }
  join("-", ["SG", lookup(var.ec2_tags , "Name"), "InstanceSecurityGroup", "2"]) = {
    "rule1" = { type = "ingress", from_port = 22, to_port = 22, protocol = "tcp" , cidr_blocks = ["10.10.0.20"], description = "For SSH"}
  }
}

existing_sg_rules = {
sg-0bd541cafc1955479 = {
# "rule1" = { type = "ingress", from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "For SSH" }
# },
#sg-0294c098f15df980e = {
#"rule1" = { type = "ingress", from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "For SSH" }
#}
} 
}
}
