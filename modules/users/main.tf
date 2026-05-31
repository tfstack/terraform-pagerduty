locals {
  users_by_email = { for user in var.users : user.email => user }

  managed_users = {
    for email, user in local.users_by_email : email => user
    if !coalesce(user.existing, false)
  }

  existing_users = {
    for email, user in local.users_by_email : email => user
    if coalesce(user.existing, false)
  }

  user_id_by_email = merge(
    { for email, user in pagerduty_user.this : email => user.id },
    { for email, user in data.pagerduty_user.existing : email => user.id }
  )

  contact_methods = {
    for item in flatten([
      for user in var.users : [
        for contact_method in coalesce(user.contact_methods, []) : {
          key              = "${user.email}:${contact_method.label}"
          user_email       = user.email
          label            = contact_method.label
          type             = contact_method.type
          address          = contact_method.address
          country_code     = contact_method.country_code
          device_type      = contact_method.device_type
          send_short_email = contact_method.send_short_email
        }
      ] if !coalesce(user.existing, false)
    ]) : item.key => item
  }

  notification_rules = {
    for item in flatten([
      for user in var.users : [
        for idx, rule in coalesce(user.notification_rules, []) : {
          key                    = "${user.email}:notification:${idx}"
          user_email             = user.email
          start_delay_in_minutes = rule.start_delay_in_minutes
          urgency                = rule.urgency
          contact_method         = rule.contact_method
        }
      ] if !coalesce(user.existing, false)
    ]) : item.key => item
  }

  handoff_notification_rules = {
    for item in flatten([
      for user in var.users : [
        for idx, rule in coalesce(user.handoff_notification_rules, []) : {
          key                       = "${user.email}:handoff:${idx}"
          user_email                = user.email
          notify_advance_in_minutes = rule.notify_advance_in_minutes
          handoff_type              = rule.handoff_type
          contact_methods           = rule.contact_methods
        }
      ] if !coalesce(user.existing, false)
    ]) : item.key => item
  }
}

resource "pagerduty_user" "this" {
  for_each = local.managed_users

  name        = each.value.name
  email       = each.value.email
  role        = each.value.role
  job_title   = each.value.job_title
  license     = each.value.license
  description = each.value.description
  color       = each.value.color
  time_zone   = each.value.time_zone
}

data "pagerduty_user" "existing" {
  for_each = local.existing_users

  email = each.key
}

resource "pagerduty_user_contact_method" "this" {
  for_each = local.contact_methods

  user_id          = local.user_id_by_email[each.value.user_email]
  type             = each.value.type
  label            = each.value.label
  address          = each.value.address
  country_code     = each.value.country_code
  device_type      = each.value.device_type
  send_short_email = each.value.send_short_email
}

resource "pagerduty_user_notification_rule" "this" {
  for_each = local.notification_rules

  user_id                = local.user_id_by_email[each.value.user_email]
  start_delay_in_minutes = each.value.start_delay_in_minutes
  urgency                = each.value.urgency

  contact_method {
    type = each.value.contact_method.type
    id = coalesce(
      each.value.contact_method.id,
      try(
        pagerduty_user_contact_method.this["${each.value.user_email}:${each.value.contact_method.label}"].id,
        null
      )
    )
  }
}

resource "pagerduty_user_handoff_notification_rule" "this" {
  for_each = local.handoff_notification_rules

  user_id                   = local.user_id_by_email[each.value.user_email]
  notify_advance_in_minutes = each.value.notify_advance_in_minutes
  handoff_type              = each.value.handoff_type

  dynamic "contact_method" {
    for_each = each.value.contact_methods
    content {
      type = contact_method.value.type
      id = coalesce(
        contact_method.value.id,
        try(
          pagerduty_user_contact_method.this["${each.value.user_email}:${contact_method.value.label}"].id,
          null
        )
      )
    }
  }
}
