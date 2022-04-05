#!/usr/bin/env nix-shell
#!nix-shell -I .fly/default.nix -p flyctl skopeo dive yq jq git -i bash

set -e
PS4=" $ "

cd "$(dirname "$0")/.."

PROJECT_NAME="$(tomlq --raw-output .app fly.toml)"

echo "Building ${PROJECT_NAME}..."

COMMAND="nix-build .fly -A eval.config.outputs.container.image"

if [ -n "$NIX_BASE_DEV" ]; then
    COMMAND="${COMMAND} --arg fly-base '(import ../../internal/nix-base {})'"
fi

echo $COMMAND
ARCHIVE_PATH=$($COMMAND)

if [ -n "$TAG" ]; then
    $(dirname "$0")/nix_push.sh $ARCHIVE_PATH
fi