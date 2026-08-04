variable "project_id" {
  type    = string
  default = "terraform-learning-503012"
}

variable "region" {
  type    = string
  default = "us-west4"
}

variable "zone" {
  type    = string
  default = "us-west4-a"
}

variable "network_self_link" {
  type    = string
  default = "default"
}

variable "subnet_01_name" {
  type    = string
  default = "default"
}

variable "subnet_02_name" {
  type    = string
  default = "default"
}