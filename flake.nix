{
  description = "nix-react-native";
  outputs = {
    templates.default = {
      path = ./template;
      description = "React Native environment for nix";
    };
  };
}
