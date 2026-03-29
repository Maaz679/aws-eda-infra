variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "eda-infra"
}

variable "instance_type" {
  description = "EC2 instance type for compute node"
  type        = string
  default     = "t2.micro"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the compute node"
  type        = string
}
