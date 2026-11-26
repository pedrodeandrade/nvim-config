-- Apply common LSP behavior to every attached language server.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Go to definition.
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
      buffer = args.buf,
      desc = "LSP go to definition",
    })

    -- Enable inlay hints when supported.
    if client and client:supports_method("textDocument/inlayHint", args.buf) then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})


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
        includeInlayVariableTypeHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
})

-- Elixir / Phoenix language server.
-- Root detection is supplied by nvim-lspconfig,
-- including support for umbrella projects.
vim.lsp.config("expert", {
  cmd = { "expert", "--stdio" },
  filetypes = {
    "elixir",
    "eelixir",
    "heex",
    "surface",
  },
})

vim.lsp.enable({ "lua_ls", "jsonls", "ts_ls", "denols", "rust_analyzer", "clangd", "expert" })

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
