-- Use two-space indentation in web languages and Elixir.
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "html",
    "css",
    "elixir",
    "eelixir",
    "heex",
  },
  callback = function(args)
    vim.bo[args.buf].expandtab = true
    vim.bo[args.buf].tabstop = 2
    vim.bo[args.buf].shiftwidth = 2
    vim.bo[args.buf].softtabstop = 2
  end,
})

-- Enable Treesitter editing features for supported filetypes.
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
    "c",
    "cpp",
    "objc",
    "objcpp",
    "elixir",
    "eelixir",
    "heex",
  },
  callback = function(args)
    local ok = pcall(vim.treesitter.start, args.buf)

    if not ok then
      return
    end

    vim.bo[args.buf].indentexpr =
      "v:lua.require'nvim-treesitter'.indentexpr()"

    local win = vim.api.nvim_get_current_win()

    vim.wo[win].foldmethod = "expr"
    vim.wo[win].foldexpr =
      "v:lua.vim.treesitter.foldexpr()"
    vim.wo[win].foldlevel = 99
  end,
})

