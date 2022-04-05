{ nix-base ? (import ./nix-base.nix {})
}:
let
  toml = (builtins.fromTOML (builtins.readFile ../fly.toml));
in
(nix-base.fly.evalSpec) {
  config = { pkgs, ... }: {
    templates.rails.enable = true;
    app.source = builtins.fetchGit ../.;
    runtimes.ruby.version = toml.requirements.ruby_version or null;
    runtimes.ruby.withJemalloc = toml.requirements.use_jemalloc or false;

    # Define additional paths required for asset compilation
    templates.rails.assetInputs = toml.requirements.asset_compilation_files or [""];

    # Define additional files required for bundling gems
    templates.rails.gemInputs = toml.requirements.gem_inputs or [""];

    # This could also be further abstracted in the nix-base modules by
    # providing an option that only takes packages as input, and adds the
    # layer. This would provide more isolation from the implementation details.
    container.additionalLayers = [
      {
        contents = with pkgs; [ ffmpeg ];
      }
    ];

    # Include the base layer which contains useful tools (ca-certs, bash, etc)
    container.includeBaseLayer = toml.requirements.include_tools or false;
  };
}
