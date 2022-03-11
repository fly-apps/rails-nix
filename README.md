This is a sample Rails app for testing [a Nix-based development and deployment system](https://github.com/fly-apps/nix-base). It inherits most behavior from Fly's [Nix modules](https://github.com/fly-apps/nix-base). The following files are interesting for understanding how the module system works.

* [default.nix](default.nix): Entry point for Nix commands. All module configuration goes here, such as customizing the Ruby version.
* [shell.nix](shell.nix): Entry point for `nix-shell`. For example, it will ensure all gem groups are loaded.
* [fly-base.nix](fly-base.nix): Importer shim for loading modules. Needs to be updated when `nix-base` updates. A helper script in `bin/update-nix` will dump the correct rev/sha256 values for the HEAD of `nix-base/main`.
* [bin/nix-build.sh](bin/nix_build.sh): Script called by `fly deploy --nix` that runs the image build and pushes the result to the Fly repository.
## Building a Docker image

If you just want to build the Docker image and see the results, you can run the following on **Linux**. Building Docker images on Darwin is not well supported.

`nix-build . -A eval.config.outputs.container.image | docker load`

This will generate a Docker image tarball and load it into your local Docker. You can inspect its contents with an amazing tool called [Dive](https://github.com/wagoodman/dive).
## Deploying on Fly.io

To deploy, use `fly deploy -i image_name`, substituting the image name from the `docker load`.

For Fly employees and enthusiasts: there's experimental support for running a remote build using `fly deploy --nix`. Using this will require a custom remote builder Docker image. Ask an admin how to get that setup. Eventually, Nix will be enabled by default on remote builder VMs.
## Using Nix in Development

The same Nix environment used in production can also be run in development.

First install Nix locally, then run `nix-shell` in the project root. You'll be popped into a shell with all the good stuff. If you want a shell with *nothing but Nix* - not inheriting `PATH` or any other environment from your system - use `nix-shell --pure`.
## Notes

Changing Ruby versions can mess with the Bootsnap cache. If errors are raised by bootsnap, try `rm -rf tmp/cache`.

Bundling gems requires an extra step to update `gemset.nix`. Run `bin/bundix` after any `Gemfile` updates.