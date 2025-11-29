{
  description = "Flaky templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f: lib.genAttrs systems f;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              statix
              deadnix
              nixfmt-tree
            ];

            shellHook = ''
              echo "Nix Shell:"
              echo "statix:        $(statix --version)"
              echo "deadnix:       $(deadnix --version)"
              echo "nixfmt-tree:   $(treefmt --version)"
              echo "nix:           $(nix --version)"
            '';
          };
        }
      );

      templates = {
        cw-kotlin = {
          path = ./cw/kotlin;
          description = "Kotlin CW (JDK 21)";
        };

        cw-haskell = {
          path = ./cw/haskell;
          description = "Haskell CW (GHC 9.6)";
        };

        rust = {
          path = ./rust;
          description = "Rust Shell";
        };

        java = {
          path = ./java;
          description = "Java Shell (JDK 21)";
        };

        go = {
          path = ./go;
          description = "Go Shell";
        };

        ocaml = {
          path = ./ocaml;
          description = "OCaml Shell";
        };

        web = {
          path = ./web;
          description = "Web Shell (Node 22)";
        };

        tex = {
          path = ./tex;
          description = "TeX Shell";
        };

        ghidra = {
          path = ./ghidra;
          description = "Ghidra Shell";
        };

        root = {
          path = ./root;
          description = "CERN ROOT Shell";
        };

        android = {
          path = ./android;
          description = "Android Shell";
        };

        sage = {
          path = ./sage;
          description = "Sage Shell";
        };

        c = {
          path = ./c;
          description = "C/C++ Shell";
        };

        redis = {
          path = ./redis;
          description = "Redis Shell";
        };

        pg = {
          path = ./pg;
          description = "Postgres Shell";
        };

        nix = {
          path = ./nix;
          description = "Nix Shell";
        };
      };
    };
}
