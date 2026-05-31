output "service_id" {
  value = module.service.service_id
}

output "service_name" {
  value = module.service.service_name
}

output "service_html_url" {
  value = module.service.service_html_url
}

output "integration_id" {
  value = module.service.integration_id
}

output "integration_key" {
  value     = module.service.integration_key
  sensitive = true
}
