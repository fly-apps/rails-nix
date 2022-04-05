#!/usr/bin/env nix-shell
#!nix-shell -I ./default.nix -p flyctl skopeo dive yq jq git -i bash

set -u
set -e

ARCHIVE_PATH=$1

echo "Pushing ${ARCHIVE_PATH} to $TAG..."
skopeo \
    copy docker-archive:"$ARCHIVE_PATH" \
    docker://$TAG \
    --dest-creds x:$FLY_API_TOKEN \
    --insecure-policy \
    --format v2s2
echo "Done."

SIZE=$(skopeo inspect --raw docker-archive://${ARCHIVE_PATH} |  jq -r '[ .layers[].size ] | add')
((SIZE_IN_MB=$SIZE/1024/1024))
echo "Image size: ${SIZE_IN_MB}MB"
