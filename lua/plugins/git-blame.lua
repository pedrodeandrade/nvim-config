return {
  "f-person/git-blame.nvim",

  event = "VeryLazy",

  keys = {
    {
      "<leader>gb",
      "<cmd>GitBlameFull<CR>",
      desc = "Git: show full blame information",
    },
  },

  opts = {
    enabled = true,

    -- Author, relative date, full date, summary.
    message_template = "  <author>, <date> • <summary>",

    -- Relative date + Brazilian full date.
    date_format = "%r • %d/%m/%Y %H:%M:%S",

    -- Show blame at the end of the current line.
    display_virtual_text = true,

    -- Never truncate the commit summary.
    max_commit_summary_length = 0,

    -- Match the editor's comment colors.
    highlight_group = "Comment",

    -- Display after a short delay.
    delay = 250,
  },

  config = function(_, opts)
    local gitblame = require("gitblame")
    gitblame.setup(opts)

    -- Show the complete blame message in a
    -- floating window with line wrapping.
    vim.api.nvim_create_user_command("GitBlameFull", function()
      local message = gitblame.get_current_blame_text()

      if not message or message == "" then
        vim.notify(
          "No Git blame information available",
          vim.log.levels.INFO
        )
        return
      end

      local width = math.max(
        20,
        math.min(90, vim.o.columns - 6)
      )

      local lines = vim.split(message, "\n", {
        plain = true,
      })

      local height = 0

      for _, line in ipairs(lines) do
        height = height + math.max(
          1,
          math.ceil(vim.fn.strdisplaywidth(line) / width)
        )
      end

      height = math.min(
        height,
        math.max(1, vim.o.lines - 6)
      )

      local buf = vim.api.nvim_create_buf(false, true)

      vim.api.nvim_buf_set_lines(
        buf, 0, -1, false, lines
      )

      vim.bo[buf].modifiable = false

      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
        col = math.max(0, math.floor((vim.o.columns - width) / 2)),
        style = "minimal",
        border = "rounded",
      })

      vim.wo[win].wrap = true
      vim.wo[win].linebreak = true

      local function close_popup()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end

      vim.keymap.set("n", "q", close_popup, {
        buffer = buf,
        silent = true,
      })

      vim.keymap.set("n", "<Esc>", close_popup, {
        buffer = buf,
        silent = true,
      })
    end, {
      desc = "Show full Git blame information",
    })
  end,
}
