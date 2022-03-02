{ pkgs ? (import ./nixpkgs.nix {})
# Path to a writeable runtime directory for running outside of containers.
, runtimeDirectory ? null
}:

let pkgs' = pkgs; in # break reference cycle
let

  pkgs = pkgs'.appendOverlays [(import ./overlays.nix)];

in

let
  # This could be part of the Fly overlay instead.
  flyImageTools = pkgs.callPackage ./image-tools.nix { };

  #
  # `callPackage` is the mechanism used for dependency injection within Nixpkgs.
  # It takes two parameters:
  #   - first a file containing a function, or a function.
  #     Its inputs are the desired dependencies in a set-pattern argument.
  #   - second is any overrides or additional inputs.
  #
  app = pkgs.callPackage (

    { stdenv
    , runCommandNoCC
    , lib
    , ruby
    , bundlerEnv
    # Groups installed in the bundler environment.
    , groups ? [ "default" ]
    }:

    let
      # Using `fetchGit` helps reduce pollution.
      # This is because instead of copying the whole directory, it copies the
      # checked-out revision + any files tracked or staged.
      src = builtins.fetchGit ./.;

      # All unique groups referenced in `gemset.nix`; should map to all groups
      # actually present in the Gemfile.
      allGroups = lib.unique (builtins.concatLists (
        lib.mapAttrsToList
        (k: v: v.groups)
        (import (src + "/gemset.nix"))
      ));

      # [ "default" "development" "test" ] - [ "default ] ⇒ [ "development" "test" ]
      selectedGroups = lib.subtractLists groups allGroups;

      gemfile =
        if groups == null
        then src + "/Gemfile"
        else (runCommandNoCC "patched-gemfile" {} ''
          cat ${src}/Gemfile > $out
          cat >> $out <<EOF

          # Mark unwanted groups as "optional" such that we don't need to rely
          # on "BUNDLE_WITHOUT" listing all these groups in an additional layer
          # of wrappers to make bundler happy with missing gems.
          ${lib.concatMapStringsSep "\n" (
            name: "group :${name}, optional: true do end"
          ) selectedGroups}
          EOF
        '')
      ;
      gems = bundlerEnv {
        name = "rails-nix-gems";
        inherit ruby groups gemfile;
        gemdir = src;
      };
    in
    stdenv.mkDerivation {
      pname = "rails-nix";
      version = "0.0.0";

      inherit src;

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
        inherit ruby;
        inherit gems;
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
    , flyImageTools
    , cacert
    , busybox
    , app
    }:

    flyImageTools.buildSpecifiedLayers {
      layeredContent = [
        { contents = [ busybox cacert ]; }
        { contents = [ app.ruby ]; }
        { contents = [ app.wrappedRuby ]; }
        {
          contents = [ app ];
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
      ];
    }
  ) {
    inherit app flyImageTools;
  };
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
