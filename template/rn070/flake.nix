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

        android = {
          defaultBuildToolsVersion = "31.0.0";
          # Same as above but following naming convention of channels in github:tadfisher/android-nixpkgs with XML
          defaultBuildToolsXML = "build-tools-31-0-0";
        };
      in
      {
        packages = {
          android-sdk = android.sdk.${system} (sdkPkgs: with sdkPkgs; [
            # Useful packages for building and testing.
            patcher-v4
            # The default build tools for react native 0.70
            # If when building the apps needs to add other version of build tools, u can add it too
            android.defaultBuildToolsXML
            build-tools-30-0-3
            cmdline-tools-latest
            emulator
            platform-tools
            platforms-android-31

            # Other useful packages for a development environment.
            # sources-android-30
            # system-images-android-30-google-apis-x86
            # system-images-android-30-google-apis-playstore-x86
          ]);

          # If u need android-studio, u can choose one of these channels
          # Be sure to add it to overlay above
          # android-studio = pkgs.androidStudioPackages.stable;
          # android-studio = pkgs.androidStudioPackages.beta;
          # android-studio = pkgs.androidStudioPackages.preview;
          # android-studio = pkgs.androidStudioPackage.canary;
        };
        devShell = with pkgs; devshell.mkShell {
          name = "android-project";
          motd = ''
            Entered the Android app development environment.
          '';
          env = [
            {
              name = "JAVA_HOME";
              value = jdk11.home;
            }
            {
              name = "ANDROID_HOME";
              value = "${android-sdk}/share/android-sdk";
            }
            {
              name = "ANDROID_SDK_ROOT";
              value = "${android-sdk}/share/android-sdk";
            }
            {
              name = "PATH";
              prefix = "${android-sdk}/share/android-sdk/emulator";
            }
            {
              name = "PATH";
              prefix = "${android-sdk}/share/android-sdk/platform-tools";
            }
            {
              name = "GRADLE_OPTS";
              prefix = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${android-sdk}/share/android-sdk/build-tools/${android.defaultBuildToolsVersion}/aapt2";
            }
          ];
          packages = [
            # Uncomment these if u decided to want to install android-studio
            # android-studio
            android-sdk
            gradle
            jdk11
          ];
        };
      }
    );
}
