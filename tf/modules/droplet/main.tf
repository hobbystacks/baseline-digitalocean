########################################################################################
# Create and initialize the new droplet.
########################################################################################
locals {
  script_directory = "${path.module}/scripts/"
  docker_directory = "${path.module}/docker-nginx/"
}

data "digitalocean_ssh_key" "main" {
  name = var.ssh_public_key
}

resource "digitalocean_droplet" "web" {
  count = 1

  name   = "${var.project_name}-${var.droplet_name}-${var.droplet_region}-${count.index + 1}"
  image  = var.droplet_image
  region = var.droplet_region
  size   = var.droplet_size
  ssh_keys = [
    data.digitalocean_ssh_key.main.id
  ]
  vpc_uuid = var.vpc_uuid

  tags = [
    "${var.project_name}-webserver",
    "${var.project_name}"
  ]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.ssh_private_key)
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/scripts/",
      "mkdir -p /var/www/apps",
    ]
  }

  provisioner "file" {
    source      = local.script_directory
    destination = "/tmp/scripts/"
  }

  provisioner "file" {
    source      = local.docker_directory
    destination = "/var/www/apps"
  }

  provisioner "remote-exec" {
    inline = [
      "bash /tmp/scripts/server-setup.sh"
    ]
  }

  lifecycle {
    create_before_destroy = true
  }
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
