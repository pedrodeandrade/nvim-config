vim.opt.number=true
vim.opt.undofile=true
vim.opt.splitbelow=true
vim.opt.splitright=true
vim.opt.expandtab=true
vim.opt.tabstop=4
vim.opt.shiftwidth=0 -- set to 0 to default to tabstop value
vim.opt.ignorecase=true
vim.opt.smartcase=false

vim.g.clipboard = "xclip"
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = " "

-- Clear the active search and its command-line text with Esc.
vim.keymap.set("n", "<Esc>", function()
    if vim.v.hlsearch == 1 then
        vim.cmd("nohlsearch")
        vim.fn.setreg("/", "")
        vim.schedule(function()
            vim.api.nvim_echo({ { "" } }, false, {})
            vim.cmd("redraw")
        end)
    end

    return "<Esc>"
end, { expr = true, silent = true })

-- Open a blank line below without leaving normal mode.
vim.keymap.set("n", "<C-CR>", "o<Esc>", { silent = true })

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
      "stevearc/oil.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("oil").setup({
          columns = { "icon" },
          keymaps = {
            ["<C-h>"] = false,
            ["<M-h>"] = "actions.select_split",
            ["<tab>"] = "actions.select",
            ["<s-tab>"] = { "actions.parent", mode = "n" },
          },
          view_options = {
            show_hidden = true,
          },
        })

        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        vim.keymap.set("n", "<space>-", require("oil").toggle_float)
      end,
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
      dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
      opts = { ensure_installed = {"lua_ls", "jsonls", "ts_ls", "rust_analyzer"} }
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
        keymap = { preset = 'super-tab' },

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
    },
    {
        "https://github.com/farmergreg/vim-lastplace",
        event = "BufReadPost",
    },
    -- Treesitter config
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter").setup({
          install_dir = vim.fn.stdpath("data") .. "/site",
        })

        require("nvim-treesitter").install({
          "lua",
          "vim",
          "typescript",
          "tsx",
          "javascript",
          "jsdoc",
          "json",
          "html",
          "css",
          "rust",
          "c_sharp"
        })
      end,
    },
    -- Tokyo night color scheme
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require("tokyonight").setup({
          style = "night", -- storm | moon | night | day
          transparent = false,
          terminal_colors = true,
          styles = {
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
          },
        })

        vim.cmd.colorscheme("tokyonight")
      end,
    }
})

-- Enable Treesitter-powered editing features for supported filetypes.
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "lua",
    "vim",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "html",
    "css",
    "rust",
    "cs",
  },
  callback = function(args)
    vim.treesitter.start(args.buf)
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

    local win = vim.api.nvim_get_current_win()
    vim.wo[win].foldmethod = "expr"
    vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[win].foldlevel = 99
  end,
})

require("fzf-lua").register_ui_select()

-- Typescript lsp config

vim.lsp.config("ts_ls", {
  init_options = {
    hostInfo = "neovim",
    maxTsServerMemory = 4096,
    disableAutomaticTypingAcquisition = true,

    preferences = {
      includeCompletionsForModuleExports = true,
      includeCompletionsForImportStatements = true,
      includeCompletionsWithSnippetText = true,
      includeCompletionsWithInsertText = true,
      includeAutomaticOptionalChainCompletions = true,
      includeCompletionsWithClassMemberSnippets = true,
      includeCompletionsWithObjectLiteralMethodSnippets = true,
      useLabelDetailsInCompletionEntries = true,
      allowIncompleteCompletions = true,

      importModuleSpecifierPreference = "shortest",
      importModuleSpecifierEnding = "auto",
      quotePreference = "single",

      autoImportFileExcludePatterns = {
        "**/dist/**",
        "**/build/**",
        "**/.next/**",
        "**/coverage/**",
      },
      preferTypeOnlyAutoImports = true,
      includePackageJsonAutoImports = "auto",

      providePrefixAndSuffixTextForRename = true,
      provideRefactorNotApplicableReason = true,
      allowRenameOfImportPath = true,
      excludeLibrarySymbolsInNavTo = true,
      displayPartsForJSDoc = true,
      generateReturnInDocTemplate = true,
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      interactiveInlayHints = true,
    },

    tsserver = {
      useSyntaxServer = "auto",
    },
  },

  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    }
  },
})

vim.lsp.enable({"lua_ls", "jsonls", "ts_ls", "denols", "rust_analyzer"})

-- diagnostics UI config
vim.diagnostic.config({
  float = {
    border = "rounded",
    source = "always",
  },
  virtual_text = {
    spacing = 2,
    prefix = "●"
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
