{ fly-base ? (import ./fly-base.nix {})
}:
let
  toml = (builtins.fromTOML (builtins.readFile ../fly.toml));
in
(fly-base.fly.evalSpec) {
  config = { pkgs, ... }: {
    templates.rails.enable = true;
    app.source = builtins.fetchGit ../.;
    runtimes.ruby.version = toml.requirements.ruby_version;
    runtimes.ruby.withJemalloc = false;

    templates.rails.assetInputs = [
      # If this dir existed, it would also be used for the assets pre-compilation
      "app/somedir"
    ];

    templates.rails.gemInputs = [
      # If this dir existed, it would also be used for the gems build
      "src/gem_dependency"
    ];

    # This could also be further abstracted in the fly-base modules by
    # providing an option that only takes packages as input, and adds the
    # layer. This would provide more isolation from the implementation details.
    container.additionalLayers = [
      {
        contents = with pkgs; toml.requirements.additional_packages;
      }
    ];

    # May not be desirable depending.
    #container.includeBaseLayer = false;
  };
}
