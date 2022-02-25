#!/usr/bin/env nix-shell
#!nix-shell -I ./nixpkgs.nix -p flyctl skopeo yq git -i bash

set -u
set -e
PS4=" $ "

cd "$(dirname "$0")/.."

FLY_AUTH_TOKEN=$1
DOCKER_TAG=$2

PROJECT_NAME="$(tomlq --raw-output .app fly.toml)"

echo "Building ${PROJECT_NAME}..."
ARCHIVE_PATH=$(nix-build . -A dockerImage)

echo "Pushing image to $DOCKER_TAG..."
skopeo \
    copy docker-archive:"$ARCHIVE_PATH" \
    docker://$DOCKER_TAG \
    --dest-creds x:$FLY_AUTH_TOKEN \
    --insecure-policy \
    --format v2s2
echo "Done."
