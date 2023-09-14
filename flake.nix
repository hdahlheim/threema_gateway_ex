{
  description = "Threema Gateway Ex";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

   outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      erlang = pkgs.beam.interpreters.erlangR26;
    in {
    devShells.default =
      pkgs.mkShell {
        env = {
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.libsodium erlang ];
        };
        buildInputs = [
          pkgs.libsodium
          pkgs.libtool
          pkgs.autoconf
          pkgs.automake
          pkgs.pkg-config
          erlang
          pkgs.beam.packages.erlangR26.rebar
          pkgs.beam.packages.erlangR26.elixir_1_15
        ];
      };
  });
}
