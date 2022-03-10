{ fly-base ? (import ./fly-base.nix {})
}:
(fly-base.fly.evalSpec) {
  config = {
    templates.rails.enable = true;
    app.source = builtins.fetchGit ./.;
    runtimes.ruby.version = "3.1.1";
  };
}
