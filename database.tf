# Create a new tag
resource "digitalocean_tag" "database-tag" {
  name = "Database"
}

resource "digitalocean_database_cluster" "mysql-example" {
  name       = "example-mysql-cluster"
  engine     = "mysql"
  version    = 8
  size       = "db-s-1vcpu-1gb"
  tags       = [digitalocean_tag.database-tag.id]
  region     = var.region
  node_count = 1

  private_network_uuid = digitalocean_vpc.web-vpc.id
}

resource "digitalocean_database_firewall" "mysql-firewall" {
    
    cluster_id = digitalocean_database_cluster.mysql-example.id
    # allow connection from resources with a given tag
    # for example if our droplets all have a tag "web" we could use web as the value
    rule {
        type = "tag"
        value = digitalocean_tag.do-tag.name
    }
}