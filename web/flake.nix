{
  description = "Web Shell (Node 22)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

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
          nodePkgs = pkgs.nodePackages_latest;
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.nodejs_22
              nodePkgs.typescript
              nodePkgs.eslint
              nodePkgs.prettier
            ];

            shellHook = ''
              echo "Web Shell (Node 22)"

              echo -n "node:       " && node -v
              echo -n "npm:        " && npm -v
              echo -n "tsc:        " && tsc -v
              echo -n "eslint:     " && eslint -v
              echo -n "prettier:   " && prettier -v
            '';
          };
        }
      );
    };
}
