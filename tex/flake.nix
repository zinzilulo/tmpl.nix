{
  description = "TeX Shell";

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

          tex = pkgs.texlive.combine {
            inherit (pkgs.texlive) scheme-full;
          };
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              tex
              pkgs.python3
            ];

            shellHook = ''
              echo "TeX Shell"
              echo -n "chktex: " && chktex --version
            '';
          };
        }
      );
    };
}
