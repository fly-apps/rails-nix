#!/bin/bash -l

cd "$(dirname "$0")/.."

exec ./bin/nix_build.sh $@
