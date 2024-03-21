terraform {
  required_providers {
    ansible = {
      source = "nbering/ansible"
      version = "1.0.4"
    }
    incus = {
      source = "lxc/incus"
      version = "0.1.1"
    }
  }
}

provider "ansible" {}
provider "incus" {}

variable "cluster_name" {
  default = "formation1"
}

resource "incus_instance" "cp0" {
  name      = "inkus-cp0"
  image     = "images:debian/trixie/cloud"
  profiles  = ["k8s-node"]
  ephemeral = false
  type = "virtual-machine"
  remote = "manjatour"
}

resource "incus_instance" "worker0" {
  name      = "inkus-worker0"
  image     = "images:debian/trixie/cloud"
  profiles  = ["k8s-node"]
  ephemeral = false
  type = "virtual-machine"
  remote = "manjatour"
}

resource "incus_instance" "worker1" {
  name      = "inkus-worker1"
  image     = "images:debian/trixie/cloud"
  profiles  = ["k8s-node"]
  ephemeral = false
  type = "virtual-machine"
  remote = "manjatour"
}

resource "incus_instance" "worker2" {
  name      = "inkus-worker2"
  image     = "images:debian/trixie/cloud"
  profiles  = ["k8s-node"]
  ephemeral = false
  type = "virtual-machine"
  remote = "tachou_eth"
}

resource "incus_instance" "worker3" {
  name      = "inkus-worker3"
  image     = "images:debian/trixie/cloud"
  profiles  = ["k8s-node"]
  ephemeral = false
  type = "virtual-machine"
  remote = "tachou_eth"
}

resource "incus_instance" "worker4" {
  name      = "inkus-worker4"
  image     = "images:debian/trixie/cloud"
  profiles  = ["k8s-node"]
  ephemeral = false
  type = "virtual-machine"
  remote = "tachou_eth"
}

resource "ansible_host" "inkus-cp0" {
    inventory_hostname = "inkus-cp0"
    groups = ["control_plane", "inkus_cluster"]
    vars = {
        ansible_host = incus_instance.cp0.ipv4_address
    }
}

resource "ansible_host" "inkus-worker0" {
    inventory_hostname = "inkus-worker0"
    groups = ["workers", "inkus_cluster"]
    vars = {
        ansible_host = incus_instance.worker0.ipv4_address
    }
}

resource "ansible_host" "inkus-worker1" {
    inventory_hostname = "inkus-worker1"
    groups = ["workers", "inkus_cluster"]
    vars = {
        ansible_host = incus_instance.worker1.ipv4_address
    }
}

resource "ansible_host" "inkus-worker2" {
    inventory_hostname = "inkus-worker2"
    groups = ["workers", "inkus_cluster"]
    vars = {
        ansible_host = incus_instance.worker2.ipv4_address
    }
}

resource "ansible_host" "inkus-worker3" {
    inventory_hostname = "inkus-worker3"
    groups = ["workers", "inkus_cluster"]
    vars = {
        ansible_host = incus_instance.worker3.ipv4_address
    }
}

resource "ansible_host" "inkus-worker4" {
    inventory_hostname = "inkus-worker4"
    groups = ["workers", "inkus_cluster"]
    vars = {
        ansible_host = incus_instance.worker4.ipv4_address
    }
}

resource "ansible_group" "inkus" {
  inventory_group_name = "inkus_cluster"
  vars = {
    ansible_user="kadmin"
    ansible_port=22
    ansible_ssh_private_key_file="~/.ssh/id_k8s_incus"
    ansible_python_interpreter="/usr/bin/python3"
  }
}