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
