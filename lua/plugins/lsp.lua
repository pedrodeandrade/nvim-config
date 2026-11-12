return {
  {
    "neovim/nvim-lspconfig",
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "jsonls", "ts_ls", "rust_analyzer", "clangd" },
    },
  },
}
