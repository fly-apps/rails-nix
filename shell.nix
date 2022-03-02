{ pkgs ? (import ./nixpkgs.nix {})}:

let newPkgs = pkgs; in # avoid cyclic reference by reassigning pkgs
let

  pkgs = newPkgs.appendOverlays [(import ./overlays.nix)];
in
let
  gems = pkgs.bundlerEnv {
    name = "development";
    gemdir = ./.;
  };
in pkgs.mkShell {
  buildInputs = [
    gems
    gems.wrappedRuby
  ];
}
