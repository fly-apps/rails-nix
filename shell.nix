{ pkgs ? (import ./nixpkgs.nix {})
}:

let
  # Using `fetchGit` helps reduce pollution.
  # This is because instead of copying the whole directory, it copies the
  # checked-out revision + any files tracked or staged.
  app-src = builtins.fetchGit ./.;
in

#
# `callPackage` is the mechanism used for dependency injection within Nixpkgs.
# It takes two parameters:
#   - first a file containing a function, or a function.
#     Its inputs are the desired dependencies in a set-pattern argument.
#   - second is any overrides or additional inputs.
#
pkgs.callPackage (

  { mkShell
  , ruby
  , bundlerEnv
  , app-src
  }:

  let
    gems = bundlerEnv {
      name = "rails-nix-gems";
      inherit ruby;
      gemdir = app-src;
    };
  in
  mkShell {
    name = "rails-nix";
    buildInputs = [
      gems
      ruby
    ];
  }

) {
  inherit app-src;
}

# If the build required, let's say, `ruby_2_6`, the last paramter could be:
#
# ```
# {
#   # ...
#   ruby = pkgs.ruby_2_6;
# }
# ```
