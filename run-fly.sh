#!/usr/bin/env nix-shell
#!nix-shell -I ./nixpkgs.nix -p flyctl skopeo yq -i bash

set -u
set -e
PS4=" $ "
set -x

PROJECT_NAME="$(tomlq --raw-output .app fly.toml)"

skopeo \
    copy docker-archive:"$(nix-build . -A dockerImage)" \
    docker://registry.fly.io/$PROJECT_NAME:latest \
    --dest-creds x:"$(flyctl auth token)" \
    --insecure-policy \
    --format v2s2

flyctl deploy -i registry.fly.io/$PROJECT_NAME:latest --remote-only
