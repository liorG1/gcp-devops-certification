variable "instance_name" {
  type        = string
  description = "The name of the VM instance"
}

variable "instance_zone" {
  type        = string
  description = "The zone to deploy the VM in"
}

variable "instance_type" {
  type        = string
  default     = "e2-micro"
  description = "The machine type for the VM"
}

variable "instance_network" {
  type        = string
  description = "The self_link of the network to attach to"
}