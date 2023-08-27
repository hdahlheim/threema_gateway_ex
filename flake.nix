{
  description = "Threema Gateway Ex";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default =
      pkgs.mkShell {
        buildInputs = [
          pkgs.libsodium
          pkgs.libtool
          pkgs.autoconf
          pkgs.automake
          pkgs.pkg-config
          pkgs.beam.packages.erlangR26.elixir_1_15
        ];
      };
  };
}
