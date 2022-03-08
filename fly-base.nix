#
# This can be replaced by any method of tracking inputs.
#   - niv     https://github.com/nmattia/niv
#   - npins   https://github.com/andir/npins
#   - Flakes  https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html 
#
# Using this simple purely-Nix shim serves as a placeholder.

let
  # Tracking https://github.com/fly-apps/nix-base/pull/3
  rev = "cdd35d244ce3b21bc2910e086da517e361744457";
  sha256 = "sha256:1i1npj0qxmf9kvf786qnrcqkr24286kzi99a9j0vii16qffv178f";
  tarball = builtins.fetchTarball {
    url = "https://github.com/fly-apps/nix-base/archive/${rev}.tar.gz";
    inherit sha256;
  };
in import tarball
