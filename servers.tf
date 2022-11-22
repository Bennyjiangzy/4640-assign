# Create a new tag
resource "digitalocean_tag" "do-tag" {
  name = "Web"
}


# Create a new Web Droplet in the sfo3 region
resource "digitalocean_droplet" "web" {
  image    = var.droplet_image
  count    = var.droplet_count
  name     = "web-${count.index + 1}"
  tags     = [digitalocean_tag.do-tag.id]
  region   = var.region
  size     = var.droplet_size
  ssh_keys = [data.digitalocean_ssh_key.benny-ssh-key.id]
  vpc_uuid = digitalocean_vpc.web-vpc.id

# if it have to delete it will create one before delete make sure the services is always running
  lifecycle {
     create_before_destroy = true
  }
}

# add new web-1 droplet to existing 4640_labs project
resource "digitalocean_project_resources" "project_attach" {
  project = data.digitalocean_project.lab-project.id
  resources = flatten([ digitalocean_droplet.web.*.urn ])
}


resource "digitalocean_loadbalancer" "public" {
  name   = "loadbalancer-1"
  region = var.region

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }
  droplet_tag = "Web"
  vpc_uuid = digitalocean_vpc.web-vpc.id
}

resource "digitalocean_firewall" "web" {

    # The name we give our firewall for ease of use                            #    
    name = "web-firewall"

    # The droplets to apply this firewall to                                   #
    droplet_ids = digitalocean_droplet.web.*.id

    # Internal VPC Rules. We have to let ourselves talk to each other
    inbound_rule {
        protocol = "tcp"
        port_range = "1-65535"
        source_tags = [digitalocean_tag.database-tag.id]
        source_load_balancer_uids = [digitalocean_loadbalancer.public.id]
        source_addresses = [digitalocean_droplet.bastion.ipv4_address_private]
    }

    inbound_rule {
        protocol = "udp"
        port_range = "1-65535"
        source_tags = [digitalocean_tag.database-tag.id]
        source_load_balancer_uids = [digitalocean_loadbalancer.public.id]
        source_addresses = [digitalocean_droplet.bastion.ipv4_address_private]
    }

    inbound_rule {
        protocol = "icmp"
        source_tags = [digitalocean_tag.database-tag.id]
        source_load_balancer_uids = [digitalocean_loadbalancer.public.id]
        source_addresses = [digitalocean_droplet.bastion.ipv4_address_private]
    }

    outbound_rule {
        protocol = "udp"
        port_range = "1-65535"
        destination_tags = [digitalocean_tag.database-tag.id]
        destination_load_balancer_uids = [digitalocean_loadbalancer.public.id] 
        destination_addresses = [digitalocean_droplet.bastion.ipv4_address_private]
    }

    outbound_rule {
        protocol = "tcp"
        port_range = "1-65535"
        destination_tags = [digitalocean_tag.database-tag.id]
        destination_load_balancer_uids = [digitalocean_loadbalancer.public.id]
        destination_addresses = [digitalocean_droplet.bastion.ipv4_address_private]
    }

    outbound_rule {
        protocol = "icmp"
        destination_tags = [digitalocean_tag.database-tag.id]
        destination_load_balancer_uids = [digitalocean_loadbalancer.public.id]
        destination_addresses = [digitalocean_droplet.bastion.ipv4_address_private]
    }
}