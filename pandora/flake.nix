{
  description = "Pandora Shell";

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

          cup = pkgs.fetchurl {
            url = "https://www2.cs.tum.edu/projects/cup/releases/java-cup-bin-11b-20160615.tar.gz";
            sha256 = "sha256-PwHWV4gjgMHl3BWT2dt7Xe2FNCm35SvFF/m8u0pl3sw=";
          };

          cupJars = pkgs.stdenv.mkDerivation {
            pname = "java-cup-jars";
            version = "11b";

            src = cup;
            sourceRoot = ".";

            installPhase = ''
              mkdir -p $out/lib
              cp java-cup-11b.jar $out/lib/
              cp java-cup-11b-runtime.jar $out/lib/
            '';
          };

          pandoraJar = pkgs.fetchurl {
            url = "https://www.doc.ic.ac.uk/pandora/newpandora/pandora.jar";
            sha256 = "sha256-OJAO4rA76Ps9jEfOVJVLGxSB2Mwiv2I/wO5ErPe2ZK4=";
          };

          pandora = pkgs.writeShellScriptBin "pandora" ''
            exec ${pkgs.jdk21}/bin/java \
              -cp "${pandoraJar}:${cupJars}/lib/*" \
              Pandora.Pandora
          '';
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.jdk21
              pandora
            ];

            shellHook = ''
              echo "Pandora Shell"
              java -version
              echo "Run: pandora"
            '';
          };
        }
      );
    };
}
