# Rails and Nix

This repo should have everything we need to work with a reasonably complex Rails app within the Nix environment.

Requirements:

- Gems should be cacheable for reuse during builds
- Assets should be cacheable for the same reason, even if this requires pulling in cached assets from another path, or using Buildkit --mount=type=cache
- A Docker image should be generated from the Nix expression from inside a Docker container that mounts a volume for the Nix store. Are any other paths required?
