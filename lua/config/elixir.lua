local M = {}

local function project_root(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == "" then
    return nil
  end

  local matches = vim.fs.find("mix.exs", {
    path = vim.fs.dirname(file),
    upward = true,
  })

  if #matches == 0 then
    return nil
  end

  return vim.fs.dirname(matches[1])
end

local function format_buffer(bufnr)
  local root = project_root(bufnr)

  if not root then
    return
  end

  local file = vim.api.nvim_buf_get_name(bufnr)
  local lines = vim.api.nvim_buf_get_lines(
    bufnr, 0, -1, false
  )

  local content = table.concat(lines, "\n")

  if vim.bo[bufnr].endofline then
    content = content .. "\n"
  end

  local result = vim.system({
    "mix",
    "format",
    "--stdin-filename",
    file,
    "-",
  }, {
    cwd = root,
    stdin = content,
    text = true,
  }):wait()

  if result.code ~= 0 then
    vim.notify(
      "Elixir formatting failed:\n" .. (result.stderr or ""),
      vim.log.levels.WARN
    )
    return
  end

  local output = result.stdout or ""

  if output == "" then
    return
  end

  local formatted = vim.split(
    output:gsub("\n$", ""),
    "\n",
    { plain = true }
  )

  if not vim.deep_equal(lines, formatted) then
    vim.api.nvim_buf_set_lines(
      bufnr, 0, -1, false, formatted
    )
  end
end

local function run_mix(args)
  local bufnr = vim.api.nvim_get_current_buf()
  local root = project_root(bufnr)

  if not root then
    vim.notify(
      "No mix.exs found",
      vim.log.levels.WARN
    )
    return
  end

  local cmd = { "mix" }
  vim.list_extend(cmd, args)

  vim.cmd("botright 15split")

  vim.fn.termopen(cmd, {
    cwd = root,
  })

  vim.cmd("startinsert")
end

local function run_test_at_cursor()
  local bufnr = vim.api.nvim_get_current_buf()
  local root = project_root(bufnr)

  if not root then
    vim.notify("No Mix project found", vim.log.levels.WARN)
    return
  end

  local file = vim.api.nvim_buf_get_name(bufnr)
  local relative = vim.fs.relpath(root, file)

  if not relative or
      not relative:match("_test%.exs$") then
    vim.notify(
      "Open an ExUnit test file",
      vim.log.levels.WARN
    )
    return
  end

  local line = vim.api.nvim_win_get_cursor(0)[1]

  run_mix({
    "test",
    relative .. ":" .. line,
  })
end

function M.setup()
  local group = vim.api.nvim_create_augroup(
    "ElixirDevelopment",
    { clear = true }
  )

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "elixir", "eelixir", "heex" },
    callback = function(args)
      local bufnr = args.buf
      local opts = {
        buffer = bufnr,
        silent = true,
      }

      -- Format current buffer.
      vim.keymap.set("n", "<leader>ef", function()
        format_buffer(bufnr)
      end, vim.tbl_extend("force", opts, {
        desc = "Elixir: format buffer",
      }))

      -- Run all project tests.
      vim.keymap.set("n", "<leader>ea", function()
        run_mix({ "test" })
      end, vim.tbl_extend("force", opts, {
        desc = "Elixir: all tests",
      }))

      -- Run current test file.
      vim.keymap.set("n", "<leader>et", function()
        local root = project_root(bufnr)
        local file = vim.api.nvim_buf_get_name(bufnr)

        if not root then
          return
        end

        local relative = vim.fs.relpath(root, file)

        if relative and
            relative:match("_test%.exs$") then
          run_mix({ "test", relative })
        else
          vim.notify(
            "Open a test file first",
            vim.log.levels.WARN
          )
        end
      end, vim.tbl_extend("force", opts, {
        desc = "Elixir: test file",
      }))

      -- Run ExUnit test at cursor.
      vim.keymap.set("n", "<leader>en", function()
        run_test_at_cursor()
      end, vim.tbl_extend("force", opts, {
        desc = "Elixir: test at cursor",
      }))

      -- Compile project.
      vim.keymap.set("n", "<leader>ec", function()
        run_mix({ "compile" })
      end, vim.tbl_extend("force", opts, {
        desc = "Elixir: compile project",
      }))

      -- Start interactive Elixir shell.
      vim.keymap.set("n", "<leader>ei", function()
        local root = project_root(bufnr)

        if not root then
          return
        end

        vim.cmd("botright 15split")

        vim.fn.termopen({
          "iex",
          "-S",
          "mix",
        }, {
          cwd = root,
        })

        vim.cmd("startinsert")
      end, vim.tbl_extend("force", opts, {
        desc = "Elixir: IEx session",
      }))
    end,
  })
end

return M
