#
# This can be replaced by any method of tracking inputs.
#   - niv     https://github.com/nmattia/niv
#   - npins   https://github.com/andir/npins
#   - Flakes  https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html
#
# Using this simple purely-Nix shim serves as a placeholder.

let
  # Use bin/update-nix.sh to get the latest values to place here
  rev = "4fc4452d660313c2300341ef0e1e5f06f6337c41";
  sha256 = "sha256:09dznnlz9v687dpirh84bpm02cs4irwrm836aqbv106m04rzrnwp";
  tarball = builtins.fetchTarball {
    url = "https://github.com/fly-apps/nix-base/archive/${rev}.tar.gz";
    inherit sha256;
  };
in import tarball
