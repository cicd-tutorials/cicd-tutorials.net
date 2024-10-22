#!/bin/sh -e

fetch_ratelimit() {
  curl -I -H "Authorization: Bearer $1" https://registry-1.docker.io/v2/ratelimitpreview/test/manifests/latest 2>&1 | grep -i ratelimit
}

target=$1
token=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:ratelimitpreview/test:pull" | jq -r .token)

if [ -n "$target" ]; then
  fetch_ratelimit $token | tee $target;
else
  fetch_ratelimit $token;
fi
