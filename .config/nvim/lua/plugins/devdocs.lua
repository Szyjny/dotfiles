return {
  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      previewer_cmd = "glow",
      previewer_args = { "--style", "dark", "-c", "--width", "80" },
      picker_cmd = "glow",
    },
    keys = {
      { "<leader>fd", "<cmd>DevdocsOpen<cr>", desc = "Wyszukaj w DevDocs" },
      { "<leader>fD", "<cmd>DevdocsOpenCurrentFloat<cr>", desc = "Dokumentacja dla aktualnego pliku (Float)" },
      { "<leader>fi", "<cmd>DevdocsInstall<cr>", desc = "Zainstaluj nową dokumentację" },
    },
  },
}
