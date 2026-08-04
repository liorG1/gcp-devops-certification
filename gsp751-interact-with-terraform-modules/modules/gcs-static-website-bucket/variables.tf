variable "name" {
  description = "The name of the bucket"
  type        = string
}

variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "location" {
  description = "Bucket location"
  type        = string
  default     = "us-west4"
}
