# Create a new VPC
resource "digitalocean_vpc" "web-vpc" {
  name     = "4640-labs2"
  region   = var.region
}