variable "region" {
  type        = string
  description = "AWS Region the instance is launched in"
  default     = ""
}

#AWS Availability zone where resources are created
variable "azs" {
  description = "(Required) The AZs where the EBS volume will exist"
  type        = list(string)
  default     = [""]
}

variable "INSTANCE_ID" {
  description = "(Required) The Instance ID of the Instance to attach the created EBS"
  type        = string
  default     = ""
}


#Size of the EBS needed to be created
variable "size" {
  description = "(Optional) The size of the drive in GiBs"
  type        = list(number)
  default     = []
}

variable "create_from_snapshot" {
  description = "Create EBS Volume from Snapshot"
  type        = bool
  default     = false
}






variable "ApplicationOwner" {
  description = "Owner of the Application"
  type        = string
  default     = ""

  validation {
   condition     = contains(["abc@hotmail.com", "abc@gmail.com"], var.ApplicationOwner)
   error_message = "Please provide a valid Application Owner"
 }
}



variable "ApplicationTeam" {
  description = "Owner of the Application"
  type        = string
  default     = ""

  validation {
   condition     = contains(["Team1","Team2"], var.ApplicationTeam)
   error_message = "Please provide a valid Application Team"
 }
}


variable "BackupSchedule" {
  description = "BackupScheduled of the Volume"
  type        = string
  default     = ""

  validation {
   condition     = contains(["DR7y","DR1y","DR1m"], var.BackupSchedule)
   error_message = "Please provide a valid BackupSchedule. Valid values are DR7y,DR1y and DR1m"
 }
}


variable "BusinessTower" {
  description = "Business Tower"
  type        = string
  default     = ""

  validation {
   condition     = contains(["abc@gmail.com","xyz@gmail.com"], var.BusinessTower)
   error_message = "Please provide a valid BusinessTower"
 }
}


variable "ServiceCriticality" {
  description = "Business Criticality of the Service"
  type        = string
  default     = ""

  validation {
   condition     = contains(["High","Low"," Medium"], var.ServiceCriticality)
   error_message = "Please provide a valid Service Criticality, Valid values are High, Low and Medium"
 }
}

variable "Environment" {
  type    = string
  default = "Dev"

validation {
   condition     = contains(["Dev", "Test" ,"Sandbox", "Staging", "Production"], var.Environment)
   error_message = "Please provide a valid value for variable Envrionment. Allowed values are Dev, Test, Sandbox, Staging and Production"
 }
}



variable "ebs_device_name" {
  type        = list(string)
  description = "Name of the EBS device to mount"
  #default     = ["/dev/xvdb", "/dev/xvdc", "/dev/xvdd", "/dev/xvde", "/dev/xvdf", "/dev/xvdg", "/dev/xvdh", "/dev/xvdi", "/dev/xvdj", "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn", "/dev/xvdo", "/dev/xvdp", "/dev/xvdq", "/dev/xvdr", "/dev/xvds", "/dev/xvdt", "/dev/xvdu", "/dev/xvdv", "/dev/xvdw", "/dev/xvdx", "/dev/xvdy", "/dev/xvdz"]
default = [""]
}




variable "create" {
  description = "(Optional) Whether to create this resource or not"
  type        = string
  default     = true
}

variable "ebs_volumes" {
  description = "(Optional) Number of EBS volumes to create"
  type        = string
  # default = "1"
}



variable "encrypted" {
  description = "(Optional) If true, the disk will be encrypted"
  type        = string
  default     = true
}

variable "iops" {
  description = "(Optional) The amount of IOPS to provision for the disk"
  type        = string
  default     = "100"
}


variable "snapshot_id" {
  description = "(Optional) A snapshot to base the EBS volume off of"
  type        = string
  default     = ""
}

variable "type" {
  description = "(Optional) The type of EBS volume"
  type        = string
  default     = "standard"
}

variable "kms_key_id" {
  description = "(Optional) The ARN for the KMS encryption key"
  type        = string
  default     = ""
}


variable "ebs_volume_tags" {
    default = {
      BusinessOwner              = "test@hotstar.com"
      Name                       = "SSB-WPX-001-P"
      OperatingSystem            = "Windows Server 2022"
      OperatingSystemSupportTeam = "test@hotmail.com"
      scheduler                  = "ec2-startstop"
      ServerProcess              = "service MS "
      ServerRoleType             = "Application"
      Subnet-id                  = "subnet-04eff055558594bd7"
      VPC-id                     = "vpc-0419802ed12eec58a"
      TicketReference            = "CHG0050760"
      DNSEntry                   = "csdasd"
      DesignDocumentLink         = "acbv"
    }
    description = "Tags for WIndows Ec2 instances"
    type        = map(string)
  }


variable "type" {
  description = "(Optional) The type of EBS volume"
  type        = string
  default     = "standard"
}

