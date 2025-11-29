{
  description = "Kotlin CW (JDK 21)";

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

      forAllSystems = f: lib.genattrs systems f;
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
              pkgs.jdk21
              pkgs.kotlin
              pkgs.gradle
              pkgs.ktlint
            ];

            shellHook = ''
              echo "Kotlin Coursework Shell (JDK 21)"
              kotlin -version
              gradle --version
              java -version
            '';
          };
        }
      );
    };
}
