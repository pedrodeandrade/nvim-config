return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>f", "<cmd>FzfLua files<cr>", desc = "Find files" },
    { "<leader>lg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
  },
  opts = {},
  config = function(_, opts)
    require("fzf-lua").setup(opts)
    require("fzf-lua").register_ui_select()
  end,
}
