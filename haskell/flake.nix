{
  description = "Haskell Shell (GHC 9.6)";

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
          hsPkgs = pkgs.haskell.packages.ghc96;
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              (hsPkgs.ghcWithPackages (
                hp: with hp; [
                  hp.tasty
                  hp.tasty-bench
                  hp.tasty-golden
                  hp.tasty-hunit
                  hp.tasty-quickcheck
                ]
              ))
              pkgs.hlint
              pkgs.cabal-install
            ];

            shellHook = ''
              echo "Haskell Shell (GHC 9.6)"
              ghc --version
              hlint --version
            '';
          };
        }
      );
    };
}
