#!/bin/bash
# сценарии для внутренних инсталляций, для vm, vagrant & so-on 
set -eu -o pipefail

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

cd ~

# 2. get install scripts
INIT_PLATFORM_RELEASE_URL="${INIT_PLATFORM_RELEASE_URL:-https://release.yva.ai/yva/vm/yva.vm.json}"
tmpd="$(get_installscripts "$INIT_PLATFORM_RELEASE_URL")"

# run installation with the same url 
export INIT_PLATFORM_RELEASE_URL
"$tmpd/${INIT_PLATFORM_INSTALL_SCENARIO:-standalone}.sh" "$@" 2>&1 > ~/install.out.txt