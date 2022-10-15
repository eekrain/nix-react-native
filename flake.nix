{ self, ... }@inputs:
{
  templates.default = {
    path = ./template;
    description = "Android application or library";
  };
}
