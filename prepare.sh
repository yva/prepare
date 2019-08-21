#!/bin/bash
set -eu -o pipefail
[ -z "${DEBUG:-}" ] || set -x

params=()
while [[ $# -gt 0 ]]; do
    case "${1}" in
        '--verbose') params+=('-vv');;
        '--data') params+=('--extra-vars' 'data=true');;
        '--ml') params+=('--extra-vars' 'ml=true');;
        '--cuda') params+=('--extra-vars' 'cuda=true');;
        '--no-common') params+=('--extra-vars' 'no_common=true');;
        '--debug') params+=('--extra-vars' 'debug=true');;
        # stub 4 bash 4.3 produces empty arguments
        '');;
        * ) params+=("$1");;
    esac
    shift
done

if which apt-get >/dev/null 2>&1; then 
  sudo apt-get install -y ansible 
  ansible-playbook -i src/inv.local.yml src/all.yml "${params[@]}"
fi 

if which yum >/dev/null 2>&1; then 
  yum install -y ansible
  ansible-playbook -i src/inv.local.yml src/all.yml "${params[@]}"
fi 
