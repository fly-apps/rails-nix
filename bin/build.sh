#!/bin/bash -l

cd "$(dirname "$0")/.."

if [ "$(uname -p)" == "arm" ]; then
  docker run --privileged -t --platform linux/amd64 -v nixdir:/nix -v $PWD:/app --workdir=/app --rm nixos/nix /app/bin/nix_build.sh
else
  exec ./bin/nix_build.sh
fi
