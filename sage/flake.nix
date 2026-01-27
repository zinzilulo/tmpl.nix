{
  description = "Sage Shell";

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
          pkgs = import nixpkgs {
            inherit system;

            overlays = [
              (final: prev: {
                sage = prev.sage.override {
                  requireSageTests = false;
                };

                singular =
                  (prev.singular.override {
                    enableDocs = false;
                  }).overrideAttrs
                    (_: {
                      doCheck = false;
                    });
              })
            ];
          };
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.sageWithDoc
            ];

            shellHook = ''
              echo "Sage Shell"
              echo -n "sage:    " && sage -v
            '';
          };
        }
      );
    };
}
