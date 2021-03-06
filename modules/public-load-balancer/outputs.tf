output "load_balancer_id" {
  description = "Load Balancer id."
  value       = azurerm_lb.lb.id
}

output "load_balancer_domain_label" {
  description = "Public FQDN of the Load Balancer. DNS provided by Azure."
  value       = azurerm_public_ip.lb.fqdn
}

output "public_ip" {
  description = "Public IP of the Load Balancer."
  value       = azurerm_public_ip.lb.ip_address
}

output "health_probe_id" {
  description = "Health Probe Id for the health checks on the load balancer."
  value       = azurerm_lb_probe.consul.id
}

output "backend_address_pool_id" {
  description = "Backend addresss pool, for use with the VM Scale Set."
  value       = azurerm_lb_backend_address_pool.lb.id
}
