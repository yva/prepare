#!/bin/bash
# сценарии для внутренних инсталляций, для vm, vagrant & so-on 
set -eu -o pipefail

# merge jsons from params from left 2 right 
function merge_json_left2right() {
  local kv
  kv="$(echo "$1" | jq -cer '.')"
  shift
  while [[ $# -gt 0 ]]; do
    if [ -z "$1" ]; then shift; continue; fi
    kv1="$(echo "$1" | jq -cer '.')"
    kv=$(printf '%s\n%s' "$kv" "$kv1" | jq -scer '.[0] * .[1]')
    shift
  done
  echo "$kv"
}

# download install scripts
function get_installscripts(){
  local url 
  url="$1"
  zipurl=$(curl -sSf "$url" | jq -cre '.assets.setup.source.url')
  dir="$(mktemp -d)"
  (
    pushd "$dir"
    curl -sSf "$zipurl" -o "$dir/setup.zip"
    unzip setup.zip
    popd
  ) 1>&2
  echo "$dir"
}

env

cd ~

# 2. get install scripts
INIT_PLATFORM_RELEASE_URL="${INIT_PLATFORM_RELEASE_URL:-https://release.yva.ai/yva/vm/yva.vm.json}"
tmpd="$(get_installscripts "$INIT_PLATFORM_RELEASE_URL")"

# 3. mege for ansible 
if [ -n "${INIT_PLATFORM_KV_OVERLOAD:-}" ] && [ -n "${INIT_PLATFORM_KV_OVERLOAD2:-}" ]; then 
  INIT_PLATFORM_KV_OVERLOAD="$( merge_json_left2right "$INIT_PLATFORM_KV_OVERLOAD" "$INIT_PLATFORM_KV_OVERLOAD2" )"
  export INIT_PLATFORM_KV_OVERLOAD
fi

# run installation with the same url 
export INIT_PLATFORM_RELEASE_URL
"$tmpd/${INIT_PLATFORM_INSTALL_SCENARIO:-standalone}.sh" "$@" 2>&1 > ~/install.out.txt