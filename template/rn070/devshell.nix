{ pkgs, config }:

with pkgs;

# Configure your development environment.
#
# Documentation: https://github.com/numtide/devshell
devshell.mkShell {
  name = "react-native-project";
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
      prefix = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${android-sdk}/share/android-sdk/build-tools/${config.android.defaultBuildToolsVersion}/aapt2";
    }
  ];
  packages = [
    # Uncomment these if u decided to want to install android-studio
    # android-studio
    android-sdk
    gradle
    jdk11
  ];
}
