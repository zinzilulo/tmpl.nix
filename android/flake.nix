{
  description = "Android Shell";

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
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.apktool
              pkgs.jadx
              pkgs.android-tools
              pkgs.jdk21
            ];

            shellHook = ''
              echo "Android Shell"
              echo "apktool version:"
              apktool --version
              echo "jadx version:"
              jadx --version
            '';
          };
        }
      );
    };
}
