variable "env_type" {
  type        = string
  default     = "FIXME"
  description = "environment type: dev, stage, prod"
}

variable "env_owner" {
  type = string
  default = "FIXME"
  description = "Who own infrastructure and project. No spaces, only lower case. Underscore is acceptable"
}
