########################################################################################
# Create and initialize the new droplet.
########################################################################################
locals {
  script_directory = "${path.module}/scripts/"
}

data "digitalocean_ssh_key" "main" {
  name = var.ssh_key
}

resource "digitalocean_droplet" "web" {
  count = 1

  name   = "${var.project_name}-web-${var.droplet_name}-${var.droplet_region}-${count.index + 1}"
  image  = var.droplet_image
  region = var.droplet_region
  size   = var.droplet_size
  ssh_keys = [
    data.digitalocean_ssh_key.main.id
  ]

  tags = []
}

########################################################################################
# Associate the resources with the specified project.
########################################################################################
# data "digitalocean_project" "main" {
#   name = var.project_name
# }

# resource "digitalocean_project_resources" "main" {
#   project = data.digitalocean_project.main.id
#   resources = [
#     digitalocean_droplet.web[*].urn
#   ]
# }
