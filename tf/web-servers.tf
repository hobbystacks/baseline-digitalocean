# Create Droplet
resource "digitalocean_droplet" "web" {
  count = 1

  name      = "${var.domain}-web-${var.droplet_name}-${var.droplet_region}-${count.index + 1}"
  image     = var.droplet_image
  region    = var.droplet_region
  size      = var.droplet_size
  ssh_keys  = [
    data.digitalocean_ssh_key.main.id
  ]

  tags = []
}