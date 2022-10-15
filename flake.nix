{
  description = "A nix template for setting up development environment required to develop react native apps using nix.";

  outputs = { self }: {
    templates = {
      rn070 = {
        path = ./template/rn070;
        description = "Nix template for react native 0.70";
      };
      rn068 = {
        path = ./template/rn070;
        description = "Nix template for react native 0.70";
      };
    };

    defaultTemplate = self.templates.rn070;
  };
}
