Build and deploy a Rails app on Fly.io using Nix.

Roughly, we want to do as much of this as possible, in order:

* Be able to specify Ruby minor versions (patch versions require more work)
* Cache gems between builds and layer them intelligently in the Docker image
* Use Nixpkgs, if possible, to define build dependencies for gems
* `rails assets:precompile` should be run during the build, its output being cached and captured in the resulting image
* The result of the build should be a Docker image ready to be pushed to Fly

## Discussion

Bundix supports [gem setup from nixpkgs](https://github.com/NixOS/nixpkgs/blob/076b65f0047fa1c7896fd78a5b7ed1e9d4c3ec7c/doc/languages-frameworks/ruby.section.md#gem-specific-configurations-and-workarounds-gem-specific-configurations-and-workarounds)
