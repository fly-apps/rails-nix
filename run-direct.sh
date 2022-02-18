#!/usr/bin/env bash

set -e
set -u
PS4=" $ "
set -x

runtimeDirectory="$PWD/__run"
out="$(nix-build --argstr runtimeDirectory "$runtimeDirectory" -A app)"
mkdir -p "$runtimeDirectory/tmp"

"$out"/bin/rails s
