# TODO: link to evalSpec docs and document this module's options
((import ./fly-base.nix {}).fly.evalSpec) {
  config = {
    templates.rails.enable = true;
    app.source = builtins.fetchGit ./.;
  };
}
