{ fly-base ? (import ./fly-base.nix {})
}:
(fly-base.fly.evalSpec) {
  config = {
    templates.rails.enable = true;
    app.source = builtins.fetchGit ./.;
  };
}
