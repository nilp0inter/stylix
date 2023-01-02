{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.stylix.fonts;

  fontType = types.submodule {
    options = {
      package = mkOption {
        description = "Package providing the font.";
        type = types.package;
      };

      name = mkOption {
        description = "Name of the font within the package.";
        type = types.str;
      };
    };
  };

in {
  options.stylix.fonts = {
    serif = mkOption {
      description = "Serif font.";
      type = fontType;
      default = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };

    sansSerif = mkOption {
      description = "Sans-serif font.";
      type = fontType;
      default = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
    };

    monospace = mkOption {
      description = "Monospace font.";
      type = fontType;
      default = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };
    };

    emoji = mkOption {
      description = "Emoji font.";
      type = fontType;
      default = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  config.fonts = {
    fonts = [
      cfg.monospace.package
      cfg.serif.package
      cfg.sansSerif.package
      cfg.emoji.package
    ];

    fontconfig.defaultFonts = {
      monospace = [ cfg.monospace.name ];
      serif = [ cfg.serif.name ];
      sansSerif = [ cfg.sansSerif.name ];
      emoji = [ cfg.emoji.name ];
    };
  };
  config.home-manager.sharedModules = [({ lib, ... }: {
    xdg.configFile."fontconfig/conf.d/20-generic-name-aliasing.conf".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
      <alias>
      <family>sans-serif</family>
      <prefer>
      <family>${cfg.sansSerif.name}</family>
      </prefer>
      </alias>
      <alias>
      <family>serif</family>
      <prefer>
      <family>${cfg.serif.name}</family>
      </prefer>
      </alias>
      <alias>
      <family>monospace</family>
      <prefer>
      <family>${cfg.monospace.name}</family>
      </prefer>
      </alias>
      </fontconfig>
    '';
  })];
  
}
