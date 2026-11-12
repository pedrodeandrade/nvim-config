local M = {}

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")

  dap.adapters["pwa-node"] = {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
      command = "js-debug-adapter",
      args = { "${port}", "127.0.0.1" },
    },
  }

  local node_configurations = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch current file (Node.js)",
      program = "${file}",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "node",
      sourceMaps = true,
      skipFiles = { "<node_internals>/**", "**/node_modules/**" },
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to Node.js (port 9229)",
      address = "localhost",
      port = 9229,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      skipFiles = { "<node_internals>/**", "**/node_modules/**" },
    },
  }

  for _, filetype in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
    dap.configurations[filetype] = vim.deepcopy(node_configurations)
  end

  dapui.setup()

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: continue" })
  vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
  vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
  vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: step out" })
  vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: toggle breakpoint" })
  vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: toggle UI" })
end

return M
