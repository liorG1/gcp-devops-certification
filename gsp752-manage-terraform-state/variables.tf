variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-west4"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "us-west4-a"
}