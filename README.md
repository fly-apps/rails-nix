This is a sample Rails app for testing [a Nix-based development and deployment system](https://github.com/fly-apps/nix-base). It inherits most behavior from Fly's [Nix modules](https://github.com/fly-apps/nix-base). The following files are interesting for understanding how the module system works.

* [default.nix](.nix/default.nix): Entry point for Nix commands. All module configuration is passed through here. This can eventually be moved to `nix-base`.
* [shell.nix](.nix/shell.nix): Entry point for `nix-shell`. It ensures all gem groups are included in the bundle environment.
* [nix-base.nix](.nix/nix-base.nix): Importer shim for loading Nix modules that fetches the `nix-base` git commit from `fly.toml`. A helper script in `.nix/update-nix-base` will update values in `fly.toml` HEAD of `nix-base/main`.
* [nix-build-image](.nix/nix-build-image): Script that will build an image and push it to the Fly repository.

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