vim.opt.number=true
vim.opt.undofile=true
vim.opt.splitbelow=true
vim.opt.splitright=true
vim.opt.expandtab=true
vim.opt.tabstop=4
vim.opt.shiftwidth=0 -- set to 0 to default to tabstop value

vim.g.clipboard = "xclip"
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = " "

-- Keep delete/change operations from overwriting the system clipboard.
local function black_hole_map(modes, lhs)
    vim.keymap.set(modes, lhs, function()
        if vim.v.register == '"' then
            return '"_' .. lhs
        end

        return '"' .. vim.v.register .. lhs
    end, { expr = true })
end

for _, lhs in ipairs({ "d", "c", "x", "s" }) do
    black_hole_map({ "n", "x" }, lhs)
end

for _, lhs in ipairs({ "D", "C", "S", "X" }) do
    black_hole_map("n", lhs)
end

-- Lazy.nvim config
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
	"clone",
	"--filter=blob:none",
	"https://github.com/folke/lazy.nvim.git",
	"--branch=stable",
	lazypath
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>f", "<cmd>FzfLua files<cr>", desc = "Find files" },
            { "<leader>lg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
        },
        opts = {},
    },
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
      opts = { ensure_installed = {"lua_ls"} },
      dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
    }
})

require("fzf-lua").register_ui_select()

vim.lsp.enable("lua_ls")

-- diagnostics UI config
vim.diagnostic.config({
  float = {
    border = "rounded",
    source = "always",
  },
  virtual_text = {
    spacing = 2,
    prefix = "●",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
