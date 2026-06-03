{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:NotAShelf/nvf";
  };

  outputs =
    { nixpkgs, nvf, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default =
        (nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            {
              config.vim = {
                luaConfigPre = ''
                  vim.g.mapleader = " "
                  vim.g.maplocalleader = " "
                  vim.opt.timeoutlen = 300
                '';

                options = {
                  tabstop = 2;
                  shiftwidth = 2;
                  expandtab = true;
                  number = true;
                  relativenumber = true;
                  completeopt = "menu,menuone,noinsert,noselect";
                };

                theme = {
                  enable = true;
                  name = "tokyonight";
                  style = "moon";
                };

                statusline.lualine.enable = true;
                ui.borders.plugins.which-key.enable = true;
                binds.whichKey.enable = true;

                visuals.nvim-web-devicons.enable = true;
                visuals.indent-blankline.enable = true;

                # === 🚀 KROK 1: SILNIK BLINK.CMP ===
                autocomplete.blink-cmp = {
                  enable = true;
                  setupOpts = {
                    keymap = {
                      preset = "default";
                      "<Tab>" = [
                        "select_next"
                        "fallback"
                      ];
                      "<S-Tab>" = [
                        "select_prev"
                        "fallback"
                      ];
                      "<CR>" = [
                        "accept"
                        "fallback"
                      ];
                    };
                    completion = {
                      list = {
                        selection = {
                          preselect = false;
                          auto_insert = false;
                        };
                      };
                      menu = {
                        draw.columns = [
                          [ "kind_icon" ]
                          [
                            "label"
                            "label_description"
                          ]
                        ];
                      };
                    };
                  };
                };

                # ===  KROK 2: UTILITY SNACKS.NVF (PICKER + EXPLORER) ===
                utility.snacks-nvim = {
                  enable = true;
                  setupOpts = {
                    picker = {
                      enabled = true;
                    };
                    explorer = {
                      enabled = true;
                    };
                    indent = {
                      enabled = true;
                    };
                    scope = {
                      enabled = true;
                    };
                  };
                };

                telescope.enable = false;

                # === KROK 3: SKRÓTY KLAWISZOWE ===
                keymaps = [
                  {
                    key = "<C-s>";
                    action = "<cmd>w<CR>";
                    mode = "n";
                    desc = "Save File";
                  }
                  {
                    key = "<C-s>";
                    action = "<cmd>w<CR><ESC>";
                    mode = "i";
                    desc = "Save File and Escape";
                  }

                  # --- SNACKS PICKER & EXPLORER SKRÓTY ---
                  {
                    key = "<leader><space>";
                    action = ":lua Snacks.picker.files()<CR>";
                    mode = "n";
                    desc = "Find Files (Root Dir)";
                  }
                  {
                    key = "<leader>ff";
                    action = ":lua Snacks.picker.files()<CR>";
                    mode = "n";
                    desc = "Find Files (Root Dir)";
                  }
                  {
                    key = "<leader>/";
                    action = ":lua Snacks.picker.grep()<CR>";
                    mode = "n";
                    desc = "Grep (Root Dir)";
                  }
                  {
                    key = "<leader>sg";
                    action = ":lua Snacks.picker.grep()<CR>";
                    mode = "n";
                    desc = "Grep (Root Dir)";
                  }
                  {
                    key = "<leader>,";
                    action = ":lua Snacks.picker.buffers()<CR>";
                    mode = "n";
                    desc = "Switch Buffer";
                  }
                  {
                    key = "<leader>:";
                    action = ":lua Snacks.picker.command_history()<CR>";
                    mode = "n";
                    desc = "Command History";
                  }
                  {
                    key = "<leader>fr";
                    action = ":lua Snacks.picker.recent()<CR>";
                    mode = "n";
                    desc = "Recent Files";
                  }
                  {
                    key = "<leader>e";
                    action = ":lua Snacks.explorer()<CR>";
                    mode = "n";
                    desc = "File Explorer (Snacks)";
                  }

                  {
                    key = "<leader>ss";
                    action = ":lua Snacks.picker.lsp_symbols()<CR>";
                    mode = "n";
                    desc = "Goto Symbol";
                  }
                  {
                    key = "<leader>sS";
                    action = ":lua Snacks.picker.lsp_workspace_symbols()<CR>";
                    mode = "n";
                    desc = "Goto Symbol (Workspace)";
                  }

                  # Trouble diagnostyka
                  {
                    key = "<leader>xx";
                    action = "<cmd>Trouble diagnostics toggle<CR>";
                    mode = "n";
                    desc = "Diagnostics (Trouble)";
                  }
                  {
                    key = "<leader>xX";
                    action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
                    mode = "n";
                    desc = "Buffer Diagnostics (Trouble)";
                  }

                  # Nawigacja okien
                  {
                    key = "<C-h>";
                    action = "<C-w>h";
                    mode = "n";
                    desc = "Go to Left Window";
                  }
                  {
                    key = "<C-j>";
                    action = "<C-w>j";
                    mode = "n";
                    desc = "Go to Lower Window";
                  }
                  {
                    key = "<C-k>";
                    action = "<C-w>k";
                    mode = "n";
                    desc = "Go to Upper Window";
                  }
                  {
                    key = "<C-l>";
                    action = "<C-w>l";
                    mode = "n";
                    desc = "Go to Right Window";
                  }
                  {
                    key = "<list-esc>";
                    action = "<cmd>noh<CR><esc>";
                    mode = "n";
                    desc = "Escape and Clear Hlsearch";
                  }

                  # LSP
                  {
                    key = "<leader>ca";
                    action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
                    mode = [
                      "n"
                      "v"
                    ];
                    desc = "Code Action";
                  }
                  {
                    key = "<leader>cr";
                    action = "<cmd>lua vim.lsp.buf.rename()<CR>";
                    mode = "n";
                    desc = "Rename Symbol";
                  }
                  {
                    key = "gd";
                    action = "<cmd>lua vim.lsp.buf.definition()<CR>";
                    mode = "n";
                    desc = "Goto Definition";
                  }
                  {
                    key = "gr";
                    action = ":lua Snacks.picker.lsp_references()<CR>";
                    mode = "n";
                    desc = "References (Snacks)";
                  }
                  {
                    key = "K";
                    action = "<cmd>lua vim.lsp.buf.hover()<CR>";
                    mode = "n";
                    desc = "Hover Definition";
                  }
                ];

                navigation.harpoon = {
                  enable = true;
                  mappings = {
                    listMarks = "<leader>h";
                    markFile = "<leader>H";
                    file1 = "<leader>1";
                    file2 = "<leader>2";
                    file3 = "<leader>3";
                    file4 = "<leader>4";
                  };
                };

                # === 🛠️ POPRAWNA NAZWA WTYCZKI CONFORM ===
                formatter.conform-nvim = {
                  enable = true;
                  setupOpts = {
                    format_on_save = {
                      timeout_ms = 500;
                      lsp_fallback = true;
                    };
                  };
                };

                # === 🛠️ POPRAWNA STRUKTURA DLA TROUBLE W NVF ===
                lsp = {
                  enable = true;
                  trouble.enable = true; # Trouble aktywowane jako część modułu LSP
                  servers.nil.setupOpts = {
                    settings = {
                      nil = {
                        formatting = {
                          command = [ "nixfmt" ];
                        };
                      };
                    };
                  };
                };

                languages = {
                  enableTreesitter = true;
                  nix.enable = true;
                  clang.enable = true;
                };
              };
            }
          ];
        }).neovim;
    };
}
