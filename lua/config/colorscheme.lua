local utils = require('utils')
local cmd = vim.cmd

utils.opt('o','termguicolors',true)
-- cmd 'silent! colorscheme elly'

cmd 'highlight LineNr ctermbg=NONE'
cmd 'highlight VertSplit ctermbg=NONE guibg=NONE'
cmd 'highlight ColorColumn ctermbg=NONE guibg=NONE'
cmd 'highlight EndOfBuffer ctermbg=NONE guibg=NONE'
cmd 'highlight Comment cterm=italic'
cmd 'highlight CursorLine ctermbg=NONE'
cmd 'highlight CursorLineNR cterm=bold ctermbg=NONE'

vim.g.nord_disable_background = true
cmd 'silent! colorscheme nord'
