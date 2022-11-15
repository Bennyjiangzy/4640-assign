# Create a bastion server
resource "digitalocean_droplet" "bastion" {
  image    = var.droplet_image
  name     = "bastion-${var.region}"
  region   = var.region
  tags     = ["bastion"]
  size     = var.droplet_size
  ssh_keys = [data.digitalocean_ssh_key.benny-ssh-key.id]
  vpc_uuid = digitalocean_vpc.web-vpc.id
}

resource "digitalocean_project_resources" "project_attach2" {
  project = data.digitalocean_project.lab-project.id
  resources = [ digitalocean_droplet.bastion.urn]
}

# firewall for bastion server
resource "digitalocean_firewall" "bastion" {
  
  #firewall name
  name = "ssh-bastion-firewall"

  # Droplets to apply the firewall to
  droplet_ids = [digitalocean_droplet.bastion.id]

  inbound_rule {
    protocol = "tcp"
    port_range = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "tcp"
    port_range = "22"
    destination_addresses = [digitalocean_vpc.web-vpc.ip_range]
  }

  outbound_rule {
    protocol = "icmp"
    destination_addresses = [digitalocean_vpc.web-vpc.ip_range]
  }
}