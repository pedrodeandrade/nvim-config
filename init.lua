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
})

require("fzf-lua").register_ui_select()
