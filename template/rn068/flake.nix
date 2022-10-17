{
  description = "My Android project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    android.url = "github:tadfisher/android-nixpkgs";
  };

  outputs = { self, nixpkgs, devshell, flake-utils, android }:
    {
      overlay = final: prev: {
        # If u need android studio set up, u should add android-studio to overlay below like:
        # android-studio
        inherit (self.packages.${final.system}) android-sdk;
      };
    }
    //
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            devshell.overlay
            self.overlay
          ];
        };

        androidConfig = {
          defaultBuildToolsVersion = "31.0.0";
          sdkPkgs = android.sdk.${system} (sdkPkgs: with sdkPkgs; [
            # Useful packages for building and testing.
            # make sure to add defaultBuildToolsVersion
            build-tools-31-0-0
            # If when building the apps needs to add other version of build tools, u can add it too
            build-tools-30-0-3
            build-tools-30-0-2
            cmdline-tools-latest
            emulator
            platform-tools
            platforms-android-31
            patcher-v4

            # Other useful packages for a development environment.
            # sources-android-30
            # system-images-android-30-google-apis-x86
            # system-images-android-30-google-apis-playstore-x86
          ]);
        };
      in
      {
        packages = {
          android-sdk = androidConfig.sdkPkgs;

          # If u need android-studio, u can choose one of these channels
          # Be sure to add it to overlay above
          # android-studio = pkgs.androidStudioPackages.stable;
          # android-studio = pkgs.androidStudioPackages.beta;
          # android-studio = pkgs.androidStudioPackages.preview;
          # android-studio = pkgs.androidStudioPackage.canary;
        };
        devShell = import ./devshell.nix { inherit pkgs androidConfig; };
      }
    );
}
