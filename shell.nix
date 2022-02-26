{ pkgs ? (import ./nixpkgs.nix {})}:

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

