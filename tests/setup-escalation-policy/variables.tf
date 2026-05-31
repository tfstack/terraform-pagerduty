variable "name" {
  type = string
}

variable "rules" {
  type = list(object({
    escalation_delay_in_minutes = number
    targets = list(object({
      type = string
      id   = string
    }))
  }))
}

variable "description" {
  type    = string
  default = null
}

variable "num_loops" {
  type    = number
  default = 1
}

variable "team_id" {
  type    = string
  default = null
}
