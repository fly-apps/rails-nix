{ fly-base ? (import ./fly-base.nix {}) }:
(import ./. { inherit fly-base; }).eval.config.outputs.shell
