{ pkgs ? import <nixpkgs> {} }:

# Original setup without bundix
#
# with pkgs;

# mkShell {
#   buildInputs = [
#     stdenv
#     libiconv
#     libxml2
#     ruby_3_0
#     postgresql_14
#     redis
#     bundix
#     sqlite
#   ];

#   BUNDLE_PATH = "vendor/bundle";
# }

# Setup with bundix: first ran `bundix -l`
with (import <nixpkgs> {});
let
  gems = bundlerEnv {
    name = "rails-nix";
    inherit ruby;
    gemdir = ./.;
  };
in stdenv.mkDerivation {
  name = "rails-nix";
  buildInputs = [gems ruby];
}