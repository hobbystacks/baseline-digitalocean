########################################################################################
# Create and initialize the new droplet.
########################################################################################
locals {
  script_directory = "${path.module}/scripts/"
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

  tags = []

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.ssh_private_key)
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # 1. Install Docker
      "apt update",
      "apt -y install apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "apt update",
      "apt-cache policy docker-ce",
      "apt -y install docker-ce",
      # "usermod -aG docker ${USER}",
      "docker -v",
      # 2. Install Docker Compose
      "mkdir -p ~/.docker/cli-plugins/",
      "curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose",
      "chmod +x ~/.docker/cli-plugins/docker-compose",
      "docker compose version",
    ]
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
