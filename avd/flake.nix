{
  description = "AVD Shell";

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
            config.allowUnfree = true;
          };

          androidEnv = pkgs.androidenv.override {
            licenseAccepted = true;
          };

          androidComposition = androidEnv.composeAndroidPackages {
            cmdLineToolsVersion = "8.0";
            platformToolsVersion = "36.0.0";
            buildToolsVersions = [ "36.0.0" ];

            platformVersions = [ "36" ];

            abiVersions = [ "arm64-v8a" ];
            systemImageTypes = [ "google_apis_playstore" ];

            includeSystemImages = true;
            includeEmulator = true;
            includeNDK = false;
            useGoogleAPIs = true;

            extraLicenses = [
              "android-sdk-license"
              "android-sdk-preview-license"
              "google-gdk-license"
              "android-sdk-arm-dbt-license"
            ];
          };

          androidSdk = androidComposition.androidsdk;
        in
        {
          default = pkgs.mkShell {
            ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
            ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";

            GRADLE_OPTS =
              "-Dorg.gradle.project.android.aapt2FromMavenOverride="
              + "${androidSdk}/libexec/android-sdk/build-tools/36.0.0/aapt2";

            buildInputs = [
              androidSdk
              pkgs.qemu_kvm
            ];

            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
              pkgs.vulkan-loader
              pkgs.libGL
            ];

            shellHook = ''
              echo "AVD Shell"
            '';
          };
        }
      );
    };
}
