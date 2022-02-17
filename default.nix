{ pkgs ? (import ./nixpkgs.nix {})
# Path to a writeable runtime directory for running outside of containers.
, runtimeDirectory ? null
}:

let
  #
  # `callPackage` is the mechanism used for dependency injection within Nixpkgs.
  # It takes two parameters:
  #   - first a file containing a function, or a function.
  #     Its inputs are the desired dependencies in a set-pattern argument.
  #   - second is any overrides or additional inputs.
  #
  app = pkgs.callPackage (

    { stdenv
    , lib
    , ruby
    , bundlerEnv
    }:

    let
      gems = bundlerEnv {
        name = "rails-nix-gems";
        inherit ruby;
        gemdir = builtins.fetchGit ./.;
      };
    in
    stdenv.mkDerivation {
      pname = "rails-nix";
      version = "0.0.0";

      # Using `fetchGit` helps reduce pollution.
      # This is because instead of copying the whole directory, it copies the
      # checked-out revision + any files tracked or staged.
      src = builtins.fetchGit ./.;

      buildInputs = [
        gems
        gems.wrappedRuby
      ];

      installPhase = ''
        cp -vr . $out

        (
        cd $out

        # build the assets
        bundle exec rails assets:precompile
        
        # Clean up any cache artifacts from assets precompilation.
        rm -r tmp/cache
        )

        ${lib.optionalString (runtimeDirectory != null) ''
        (
        cd $out
        # `tmp` is forced to be relative to `Rails.root`.
        rm -vrf tmp
        ln -vs "${runtimeDirectory}/tmp" tmp

        # TODO Make presence of sqlite for production use configurable
        # These databases could be configured differently if sqlite was desired.
        ln -vs "${runtimeDirectory}/db/development.sqlite3" db/development.sqlite3
        ln -vs "${runtimeDirectory}/db/production.sqlite3" db/production.sqlite3
        ln -vs "${runtimeDirectory}/db/schema.rb" db/schema.rb
        )
        ''}
      '';

      passthru = {
        inherit (gems) wrappedRuby;
      };
    }

  ) {
    #
    # If the build required, let's say, `ruby_2_6`, this could be injected like so:
    #
    # ```
    # ruby = pkgs.ruby_2_6;
    # ```
    #
  };

  dockerImage = pkgs.callPackage (

    { lib
    , dockerTools
    , cacert
    , busybox
    #, bash
    #, coreutils
    }:
    dockerTools.buildLayeredImage {
      name = "${app.name}-container";
      contents = [
        # Those are only needed for interactive use (e.g. `docker exec -it ... sh`)
        # bash
        # coreutils
        # or
        busybox

        # Makes SSL stuff happy
        cacert

        # Makes the app's binstubs directly available in PATH
        # Transitively also makes it present at the root of the image.
        app
      ];
      config = {
        # Directly reference the store path means this command works even if the
        # application isn't added to the contents.
        Cmd = [ "${app}/bin/rails" "server" ];
        # This would work too since we're importing `app` as a layer content.
        # Cmd = [ "rails" "server" ];
      };
      extraCommands = lib.optionalString (runtimeDirectory != null) ''
        mkdir -p ./${runtimeDirectory}/tmp
      '';
    }

  ) {};
in
  {
    inherit
      app
      dockerImage

      # Added for making `nix why-depends` easier. Uncomment and use like:
      #
      #     nix why-depends -f ./. app pkgs.perl
      #
      #pkgs
    ;
  }
