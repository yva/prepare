#!/bin/bash
set -eu -o pipefail
[ -z "${DEBUG:-}" ] || set -x


if which apt-get >/dev/null 2>&1; then 
  sudo apt-get install -y ansible 
  ansible-playbook -i src/inv.local.yml src/main.yml
fi 

if which yum >/dev/null 2>&1; then 
  yum install -y ansible
  ansible-playbook -i src/inv.local.yml src/main.yml
fi 
