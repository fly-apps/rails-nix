#
# This can be replaced by any method of tracking inputs.
#   - niv     https://github.com/nmattia/niv
#   - npins   https://github.com/andir/npins
#   - Flakes  https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html
#
# Using this simple purely-Nix shim serves as a placeholder.

let
  # Tracking https://github.com/fly-apps/nix-base/pull/3
  rev = "06c67e6c54e8942d678a2e8abcdc4f5c1846e371";
  sha256 = "sha256:0d68kmcmn95nhfp18vnp0k6v48lmi5g7kgymwsz0bv5csg0mp1np";
  tarball = builtins.fetchTarball {
    url = "https://github.com/fly-apps/nix-base/archive/${rev}.tar.gz";
    inherit sha256;
  };
in import tarball
