#
# This can be replaced by any method of tracking inputs.
#   - niv     https://github.com/nmattia/niv
#   - npins   https://github.com/andir/npins
#   - Flakes  https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html
#
# Using this simple purely-Nix shim serves as a placeholder.

let
  # Tracking https://github.com/fly-apps/nix-base/pull/3
  rev = "5942668b5c0054a4dd962f93e42dd066c80da417";
  sha256 = "sha256:0anvxk77b57dgir5l7zmgz02j3rkqibzfnk0bb6dla1i0dw6hbmy";
  tarball = builtins.fetchTarball {
    url = "https://github.com/fly-apps/nix-base/archive/${rev}.tar.gz";
    inherit sha256;
  };
in import tarball
