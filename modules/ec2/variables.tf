variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "ec2_sg" {
  description = "Security Group ID for EC2 instances"
  type        = string
}

variable "instance_profile" {
  description = "IAM Instance Profile name"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "target_group" {
  description = "ALB Target Group ARN"
  type        = string
}