variable "project_id" {
  type        = string
  default     = "terraform-learning-503012"
}

variable "region" {
  type        = string
  default     = "us-west4"
}

variable "zone" {
  type        = string
  default     = "us-west4-a"
}

variable "alert_email" {
  type        = string
  default     = "lior.getahun4@example.com" # שנה לכתובת המייל האמיתית שלך לקבלת ההתרעה
}