{ fly-base ? (import ./fly-base.nix {})
}:
(fly-base.fly.evalSpec) {
  config = { pkgs, ... }: {
    templates.rails.enable = true;
    app.source = builtins.fetchGit ./.;
    runtimes.ruby.version = "3.1.1";
    runtimes.ruby.withJemalloc = false;

    # This could also be further abstracted in the fly-base modules by
    # providing an option that only takes packages as input, and adds the
    # layer. This would provide more isolation from the implementation details.
    container.additionalLayers = [
      {
        contents = with pkgs; [
          ffmpeg
        ];
      }
    ];
  };
}
