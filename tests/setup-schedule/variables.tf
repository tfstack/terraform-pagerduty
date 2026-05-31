variable "name" {
  type = string
}

variable "time_zone" {
  type = string
}

variable "layers" {
  type = list(object({
    name                         = string
    start                        = string
    rotation_virtual_start       = string
    rotation_turn_length_seconds = number
    users                        = list(string)
    end                          = optional(string)
  }))
}

variable "description" {
  type    = string
  default = null
}

variable "team_id" {
  type    = string
  default = null
}
