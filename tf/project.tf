resource "digitalocean_project" "dev" {
  name        = "${var.domain}"
  description = "HobbyStacks Development"
  purpose     = "Service or API"
  environment = "Development"
  resources   = digitalocean_droplet.web[*].urn
}