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

-- require('dap-python').setup('/usr/bin/python') -- This doesn't work for some reason
-- require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
require('dap-python').setup('/Users/kezra/Library/Caches/pypoetry/virtualenvs/rook-usGgVjGY-py3.9/bin/python')

-- require("neodev").setup({
--   library = { plugins = { "nvim-dap-ui" }, types = true },
-- })

-- Suggested mappings:
-- nnoremap <silent> <leader>dn :lua require('dap-python').test_method()<CR>
-- nnoremap <silent> <leader>df :lua require('dap-python').test_class()<CR>
-- vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>
