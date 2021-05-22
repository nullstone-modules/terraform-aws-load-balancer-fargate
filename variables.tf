variable "name" {
  description = "Unique name used to create infrastructure resources"
  type        = string
}

variable "tags" {
  description = "A collection of tags to apply to infrastructure resources"
  type        = map(string)
}

variable "https" {
  description = ""
  type = object({
    enabled : bool
    certificate_arn : string
  })
  default = {
    enabled         = false
    certificate_arn = ""
  }

  validation {
    condition     = var.https.enabled && var.https.certificate_arn == ""
    error_message = "If https is enabled, certificate arn must be specified."
  }
}

variable "service" {
  description = "Configuration to connect the load balancer to the service"
  type = object({
    port : number
    security_group_id : string
  })
}

variable "network" {
  description = "Configuration for the load balancer in a network"
  type = object({
    vpc_id : string
    subnet_ids : list(string)
  })
}

variable "enable_access_logs" {
  description = "Enable this to log all traffic to an s3 bucket"
  type        = bool
  default     = false
}
