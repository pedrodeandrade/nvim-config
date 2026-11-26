return {
  "esmuellert/codediff.nvim",

  cmd = "CodeDiff",

  keys = {
    {
      "<leader>gc",
      "<cmd>CodeDiff<cr>",
      desc = "Git: view changes",
    },
    {
      "<leader>gh",
      "<cmd>CodeDiff history<CR>",
      desc = "Git: commit history",
    }
  },

  opts = {
    explorer = {
      -- Automatically preview the selected file.
      auto_open_on_cursor = true,

      -- Display changed files grouped by directories.
      view_mode = "tree",
      flatten_dirs = false,
    },

    keymaps = {
      view = {
        -- Enter stages/unstages a file.
        toggle_stage = "<leader><Space>",

        -- Escape returns to the explorer from a diff pane.
        focus_explorer = "<Esc>",
      },

      explorer = {
        -- Disable Enter's original selection action.
        select = false,

        -- Directory navigation.
        fold_close = "-",
        fold_open = "=",
      },
    },
  },

  config = function(_, opts)
    require("codediff").setup(opts)

    -- Focus the rightmost diff pane from the explorer.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup(
        "CodeDiffNavigation",
        { clear = true }
      ),
      pattern = "codediff-explorer",
      callback = function(args)
        vim.keymap.set("n", "<CR>", function()
          local current_tab = vim.api.nvim_get_current_tabpage()
          local target_win = nil
          local rightmost_col = -1

          for _, win in ipairs(
            vim.api.nvim_tabpage_list_wins(current_tab)
          ) do
            local config = vim.api.nvim_win_get_config(win)

            if config.relative == "" then
              local col = vim.api.nvim_win_get_position(win)[2]

              if col > rightmost_col then
                rightmost_col = col
                target_win = win
              end
            end
          end

          if target_win then
            vim.api.nvim_set_current_win(target_win)
          end
        end, {
          buffer = args.buf,
          silent = true,
          desc = "CodeDiff: focus modified diff pane",
        })
      end,
    })
  end,
}

