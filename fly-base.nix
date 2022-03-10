#
# This can be replaced by any method of tracking inputs.
#   - niv     https://github.com/nmattia/niv
#   - npins   https://github.com/andir/npins
#   - Flakes  https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html
#
# Using this simple purely-Nix shim serves as a placeholder.

let
  # Tracking https://github.com/fly-apps/nix-base/pull/3
  rev = "3c090bb078f811b009cf451e75c42ed226a4cfd8";
  sha256 = "sha256:1r9vkjhn225xpyjpfn2zba3j9j4xmshwh9ac13ycdbf3yyzbrr3r";
  tarball = builtins.fetchTarball {
    url = "https://github.com/fly-apps/nix-base/archive/${rev}.tar.gz";
    inherit sha256;
  };
in import tarball
