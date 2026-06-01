{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:NotAShelf/nvf";
  };

  outputs = { nixpkgs, nvf, ... }: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = (nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [
        {
          config.vim = {
            theme.enable = true;
            theme.name = "tokyonight";
            statusline.lualine.enable = true;
            telescope.enable = true;

            navigation.harpoon = {
              enable = true;
              mappings = {
                file1 = "<leader>1";
                file2 = "<leader>2";
                file3 = "<leader>3";
                file4 = "<leader>4";
                toggleMenu = "<leader>h";
                addFile = "<leader>a";
              };
            };

            languages = {
              enableLSP = true;
              enableTreesitter = true;
              nix.enable = true; 
            };
          };
        }
      ];
    }).neovim;
  };
}

