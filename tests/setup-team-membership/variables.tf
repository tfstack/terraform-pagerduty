variable "memberships" {
  type = map(object({
    team_id = string
    user_id = string
    role    = optional(string)
  }))
}
