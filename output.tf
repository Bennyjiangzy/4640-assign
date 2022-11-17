# output the internal ip for webserver
output "server_ip" {
    value = digitalocean_droplet.web.*.ipv4_address_private
}

#output the bastion host ip
output "bastion_ip" {
    value = digitalocean_droplet.bastion.ipv4_address
}

#output the database connection uri
output "database_uri" {
    value = nonsensitive(digitalocean_database_cluster.mysql-example.uri)
}

#output the loadbalancer ip
output "loadbalancer_ip"{
    value = digitalocean_loadbalancer.public.ip
}
