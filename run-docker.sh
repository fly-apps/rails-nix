#!/usr/bin/env bash

set -e
set -u
PS4=" $ "
set -x

image="$(nix-build -A eval.config.outputs.container.image)"
image_id="$(docker load --quiet < "$image" | sed -e 's/^[^:]\+:\s*//')"

exec docker \
	run \
	-e RAILS_LOG_TO_STDOUT=yes \
	-e RAILS_ENV=production \
	-e SECRET_KEY_BASE=hi \
	-e PORT=3000 \
	--publish 3000:3000 \
	"$image_id"
