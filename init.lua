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
    },
    {
      'saghen/blink.cmp',
      -- optional: provides snippets for the snippet source
      dependencies = { 'rafamadriz/friendly-snippets' },

      -- use a release tag to download pre-built binaries
      version = '1.*',
      -- AND/OR build from source
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source with:
      -- build = 'nix run .#build-plugin',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = 'default' },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono'
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = false } },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
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
