((import ./fly-base.nix {}).fly.evalSpec) {
  config = {
    templates.rails.enable = true;
    app.source = builtins.fetchGit ./.;
  };
}
