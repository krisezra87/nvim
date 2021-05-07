local utils = require('utils')
local cmd = vim.cmd

-- Delete Fugitive buffers when they close
vim.api.nvim_exec([[
augroup deleteBuffers
    au!
    au BufReadPost fugitive://* set bufhidden=delete
augroup END
]],false)

cmd 'set tags^=./.git/tags;'

cmd 'command! GH :Gedit HEAD^'

-- Conflict resolution stuff from https://medium.com/prodopsio/solving-git-merge-conflicts-with-vim-c8a8617e3633

-- nnoremap <leader>gd :Gvdiff<CR>
-- nnoremap gdh :diffget //2<CR>
-- nnoremap gdl :diffget //3<CR>
