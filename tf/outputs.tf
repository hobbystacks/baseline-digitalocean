output "web_servers_urn" {
    value = digitalocean_droplet.web.*.urn
}