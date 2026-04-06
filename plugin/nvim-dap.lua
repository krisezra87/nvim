-- All things related to NVIM DAP

vim.keymap.set("n", "<leader>dr", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<leader>do", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<leader>di", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<leader>dO", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<Leader>p", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<Leader>P", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<Leader>dlp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set("n", "<Leader>drpl", ":lua require'dap'.repl.open()<CR>")
vim.keymap.set("n", "<Leader>dl", ":lua require'dap'.run_last()<CR>")
vim.keymap.set("n", "<Leader>ds", ":lua require'dap'.disconnect({ terminateDebuggee = true })<CR>")
vim.keymap.set("n", "<Leader>dt", ":lua require'dap'.terminate()<CR>")

require('nvim-dap-virtual-text').setup()
require('dapui').setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

local pythonPath = function()
    local cwd = vim.loop.cwd()
    -- Check for common Poetry venv locations
    local poetry_venv = cwd .. "/.venv/bin/python"
    if vim.fn.executable(poetry_venv) == 1 then
        return poetry_venv
    end
    -- Fallback to system python if not found locally
    return "/usr/bin/python"
end

require('dap-python').setup(pythonPath())
dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = pythonPath(),
    }
}

require("dapui").setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.4 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.1 },
      },
      position = "left",
      size = 5,
    },
    {
      elements = {
        { id = "repl", size = 0.6 },
        { id = "console", size = 0.4 },
      },
      position = "bottom",
      size = 15,
    },
  },
})

-- Suggested mappings:
-- nnoremap <silent> <leader>dn :lua require('dap-python').test_method()<CR>
-- nnoremap <silent> <leader>df :lua require('dap-python').test_class()<CR>
-- vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>
