{
  description = "nix-react-native";

  # To update all inputs:
  # inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = (
    system
  ) // {
    defaultTemplate.path = ./template;
    defaultTemplate.description = "nix flake new 'github:numtide/devshell'";
  };
}
