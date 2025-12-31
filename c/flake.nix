{
  description = "C/C++ Shell";

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
              pkgs.gcc
              pkgs.clang
              pkgs.clang-tools
              pkgs.cmake
              pkgs.ninja
              pkgs.pkg-config
              pkgs.gdb
            ];

            shellHook = ''
              echo "C/C++ Shell"
              echo -n "gcc:     " && gcc --version | head -n1
              echo -n "clang:   " && clang --version | head -n1
              echo -n "cmake:   " && cmake --version | head -n1
            '';
          };
        }
      );
    };
}
