#!/bin/bash

set -eu
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR
set -o pipefail

export PROJECT_DIR=$(pwd)
export TERRAFORM_DIR=$PROJECT_DIR/incus_tf/
export ANSIBLE_DIR=$PROJECT_DIR/ansible/
export ANSIBLE_INVENTORY=$PROJECT_DIR/ansible/terraform-inventory.py
export ANSIBLE_PLAYBOOK=$PROJECT_DIR/ansible/00-full.yml
export ANSIBLE_TF_DIR=$TERRAFORM_DIR

###############################################################################
# Program Functions
###############################################################################

_setup_full() {
  printf "DON'T FORGET to unlock your infra SSH KEY !\\n"
  printf "##############################################\\n"
  _setup_terraform
  # _setup_k3s_ansible
  _setup_ansible
}

_setup_terraform() {
  printf "Setup Terraform resources\\n"
  printf "##############################################\\n"
  cd "$TERRAFORM_DIR"
  terraform init
  terraform plan
  terraform apply -auto-approve 
  cd "$PROJECT_DIR"
}

_setup_ansible() {
  printf "Setup infra VPS using Ansible\\n"
  printf "##############################################\\n"
  cd "$ANSIBLE_DIR"
  ansible-playbook -i ${ANSIBLE_INVENTORY} ${ANSIBLE_PLAYBOOK} #-K #-vv
  cd "$PROJECT_DIR"
}

_destroy_infra() {
  printf "DESTROY Terraform resources\\n"
  printf "##############################################\\n"
  cd "$TERRAFORM_DIR"
  terraform destroy -auto-approve
}

_recreate_infra() {
  printf "DESTROY AND REPROVISION\\n"
  printf "##############################################\\n"
  _destroy_infra
  _setup_full
}

_main() {

  if [[ "${1:-}" =~ ^setup_terraform$  ]]
  then
    _setup_terraform
  elif [[ "${1:-}" =~ ^setup_ansible$  ]]
  then
    _setup_ansible
  elif [[ "${1:-}" =~ ^destroy$  ]]
  then
    _destroy_infra
  elif [[ "${1:-}" =~ ^recreate$  ]]
  then
    _recreate_infra
  elif [[ "${1:-}" =~ ^setup_full$  ]]
  then
    _setup_full
  elif [[ "${1:-}" =~ ^setup_all$  ]]
  then
    _setup_full
  else
    printf "error : check script for usage\\n"
  fi
}

# Call `_main` after everything has been defined.
_main "$@"
