variable "memberships" {
  description = "Team memberships keyed by a stable identifier (for example user email). Values may reference apply-time team_id and user_id."
  type = map(object({
    team_id = string
    user_id = string
    role    = optional(string)
  }))
}
