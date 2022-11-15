output "server_ip" {
    value = digitalocean_droplet.web.*.ipv4_address
}

output "bastion_ip" {
    value = digitalocean_droplet.bastion.ipv4_address
}

output "database_uri" {
    value = nonsensitive(digitalocean_database_cluster.mysql-example.uri)
}


output "loadbalancer_ip"{
    value = digitalocean_loadbalancer.public.ip
}
