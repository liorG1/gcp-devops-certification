variable "project_id" {
  description = "The GCP Project ID"
  type        = string
  default     = "terraform-learning-503012"
}

variable "region" {
  description = "The GCP Region"
  type        = string
  default     = "us-west4"
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "example-vpc"
}
