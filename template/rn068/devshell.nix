{ pkgs, androidConfig }:

with pkgs;

# Configure your development environment.
#
# Documentation: https://github.com/numtide/devshell
devshell.mkShell {
  name = "react-native-project";
  motd = ''
    Entered the Android app development environment.
  '';
  devshell.startup.check_gitignore.text = ''
    if ! grep -q ".direnv" ./.gitignore; then
      echo "adding .direnv dir to gitignore"
      echo -e "\n\n#direnv\n.direnv" >> ./.gitignore
    fi
  '';
  env = [
    {
      name = "JAVA_HOME";
      value = jdk11.home;
    }
    {
      name = "GRADLE_OPTS";
      value = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${android-sdk}/share/android-sdk/build-tools/${androidConfig.defaultBuildToolsVersion}/aapt2";
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
  ];
  packages = [
    # Uncomment these if u decided to want to install android-studio
    # android-studio
    android-sdk
    gradle
    jdk11
  ];
}
