return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
  },
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "jsonls",
        "ts_ls",
        "rust_analyzer",
        "clangd",
        "expert",
      },
      automatic_enable = false,
    },
  },
}

