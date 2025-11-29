{
  description = "OCaml Shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

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
          pkgs = nixpkgs.legacyPackages.${system};

          ocamlPkgs = pkgs.ocamlPackages;
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              ocamlPkgs.ocaml
              ocamlPkgs.dune_3
              ocamlPkgs.findlib
              pkgs.ocamlformat
            ];

            shellHook = ''
              echo "OCaml Shell"
              echo -n "OCaml:        " && ocamlc -version
              echo -n "Dune:         " && dune --version
              echo -n "ocamlformat:  " && ocamlformat --version
            '';
          };
        }
      );
    };
}
