

# Sur archlinux/manjaro sans snap les VM lxd/incus doivent avoir secureboot desactivé
# lxc profile set default security.secureboot=false

incus admin init # see tachou preseed file for config

incus network create macvlan parent=wlp0s20f3 --type macvlan

incus profile create k8s-node
incus profile edit k8s-node # paste config the yaml file here

incus launch images:debian/trixie/cloud --vm --profile k8s-node inkus-cp0

incus config trust add <legiox> # on the remote
incus remote add <name> <token> # on the client