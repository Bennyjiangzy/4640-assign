data "digitalocean_ssh_key" "benny-ssh-key" {
  name = "benny-ssh"
}

data "digitalocean_project" "lab-project" {
  name = "benny-test"
}