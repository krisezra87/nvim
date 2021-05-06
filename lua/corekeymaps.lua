local utils = require('utils')
local cmd = vim.cmd

-- Normal Mode Mappings
utils.map('n','<BS>','<C-^>')
utils.map('n','<C-J>','<C-W>j')
utils.map('n','<C-K>','<C-W>k')
utils.map('n','<C-H>','<C-W>h')
utils.map('n','<C-L>','<C-W>l')

-- Use arrow keys for resizing windows
utils.map('n','<Up>','<C-W>+')
utils.map('n','<Down>','<C-W>-')
utils.map('n','<Left>','<C-W><')
utils.map('n','<Right>','<C-W>>')

-- Copy the full path of the open buffer
utils.map('n','cp',':let @" = expand("%")<cr>')

-- Open a terminal
utils.map('n','<leader><space>',':botright vert terminal<cr>')

-- tnoremap section
utils.map('t','<C-J>','<C-W>j')
utils.map('t','<C-K>','<C-W>k')
utils.map('t','<C-H>','<C-W>h')
utils.map('t','<C-L>','<C-W>l')
utils.map('t','<Esc><Esc>','<C-\\><C-n>')
utils.map('t','OD','<left>')
utils.map('t','OC','<right>')
utils.map('t','OA','<up>')
utils.map('t','OB','<down>')

-- xnoremap section
utils.map('x','<','<gv')
utils.map('x','>','>gv')

cmd ':command E Explore'
