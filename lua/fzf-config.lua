-- File navigation
vim.keymap.set('n', '<leader>f', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>b', '<cmd>FzfLua buffers<cr>', { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>h', '<cmd>FzfLua help_tags<cr>', { desc = 'Help tags' })

-- Ripgrep searches
vim.keymap.set('n', '<leader>rg', '<cmd>FzfLua grep_project<cr>', { desc = 'Ripgrep project' })
vim.keymap.set('n', '<leader>rw', '<cmd>FzfLua grep_cword<cr>', { desc = 'Ripgrep word under cursor' })
vim.keymap.set('n', '<leader>rl', '<cmd>FzfLua live_grep<cr>', { desc = 'Live ripgrep' })
vim.keymap.set('n', '<leader>rb', '<cmd>FzfLua grep_curbuf<cr>', { desc = 'Ripgrep current buffer' })

-- Git integration
vim.keymap.set('n', '<leader>gc', '<cmd>FzfLua git_commits<cr>', { desc = 'Git commits' })
vim.keymap.set('n', '<leader>gs', '<cmd>FzfLua git_status<cr>', { desc = 'Git status' })

