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
  name      = "kluster-cp0"
  image     = "images:debian/trixie/cloud"
  profiles  = ["k8s-node"]
  ephemeral = false
  type = "virtual-machine"
  remote = "manjatour"
  running = true
  config = {
    "user.access_interface" = "enp5s0"
  }
}

# resource "incus_instance" "backup-s3" {
#   name      = "backup-s3"
#   image     = "images:debian/trixie/cloud"
#   profiles  = ["k8s-node"]
#   ephemeral = false
#   type = "virtual-machine"
#   remote = "tachou_eth"
#   running = true
#   config = {
#     "user.access_interface" = "enp5s0"
#   }
# }

resource "incus_instance" "worker0" {
  name      = "kluster-worker0"
  image     = "images:debian/trixie/cloud"
  profiles  = ["k8s-node"]
  ephemeral = false
  type = "virtual-machine"
  remote = "manjatour"
  running = true
  config = {
    "user.access_interface" = "enp5s0"
  }
}

resource "incus_instance" "worker1" {
  name      = "kluster-worker1"
  image     = "images:debian/trixie/cloud"
  profiles  = ["k8s-node"]
  ephemeral = false
  type = "virtual-machine"
  remote = "manjatour"
  running = true
  config = {
    "user.access_interface" = "enp5s0"
  }
}

resource "incus_instance" "worker2" {
  name      = "kluster-worker2"
  image     = "images:debian/trixie/cloud"
  profiles  = ["k8s-node"]
  ephemeral = false
  type = "virtual-machine"
  remote = "tachou_eth"
  running = true
  config = {
    "user.access_interface" = "enp5s0"
  }
}

resource "incus_instance" "worker3" {
  name      = "kluster-worker3"
  image     = "images:debian/trixie/cloud"
  profiles  = ["k8s-node"]
  ephemeral = false
  type = "virtual-machine"
  remote = "tachou_eth"
  running = true
  config = {
    "user.access_interface" = "enp5s0"
  }
}

resource "incus_instance" "worker4" {
  name      = "kluster-worker4"
  image     = "images:debian/trixie/cloud"
  profiles  = ["k8s-node"]
  ephemeral = false
  type = "virtual-machine"
  remote = "tachou_eth"
  running = true
  config = {
    "user.access_interface" = "enp5s0"
  }
}

resource "ansible_host" "kluster-cp0" {
    inventory_hostname = "kluster-cp0"
    groups = ["control_plane", "kluster_cluster"]
    vars = {
        ansible_host = incus_instance.cp0.ipv4_address
    }
}

# resource "ansible_host" "backup-s3" {
#     inventory_hostname = "backup-s3"
#     vars = {
#         ansible_host = incus_instance.backup-s3.ipv4_address
#     }
# }


resource "ansible_host" "kluster-worker0" {
    inventory_hostname = "kluster-worker0"
    groups = ["workers", "kluster_cluster"]
    vars = {
        ansible_host = incus_instance.worker0.ipv4_address
    }
}

resource "ansible_host" "kluster-worker1" {
    inventory_hostname = "kluster-worker1"
    groups = ["workers", "kluster_cluster"]
    vars = {
        ansible_host = incus_instance.worker1.ipv4_address
    }
}

resource "ansible_host" "kluster-worker2" {
    inventory_hostname = "kluster-worker2"
    groups = ["workers", "kluster_cluster"]
    vars = {
        ansible_host = incus_instance.worker2.ipv4_address
    }
}

resource "ansible_host" "kluster-worker3" {
    inventory_hostname = "kluster-worker3"
    groups = ["workers", "kluster_cluster"]
    vars = {
        ansible_host = incus_instance.worker3.ipv4_address
    }
}

resource "ansible_host" "kluster-worker4" {
    inventory_hostname = "kluster-worker4"
    groups = ["workers", "kluster_cluster"]
    vars = {
        ansible_host = incus_instance.worker4.ipv4_address
    }
}


resource "ansible_group" "all" {
  inventory_group_name = "all"
  vars = {
    ansible_user="kadmin"
    ansible_port=22
    ansible_ssh_private_key_file="~/.ssh/id_k8s_incus"
    ansible_python_interpreter="/usr/bin/python3"
  }
}