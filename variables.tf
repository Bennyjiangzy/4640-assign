variable "do_token" {}

#Set the default region to sfo3
variable "region" {
    type  = string
    default = "sfo3"
}

#Set the default droplet count
variable "droplet_count"{
    type = number
    default = 2
}

variable "droplet_size"{
    type = string
    default = "s-1vcpu-512mb-10gb"
}

variable "droplet_image"{
    type = string
    default = "rockylinux-9-x64"
}

