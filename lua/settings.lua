-- Neovim core settings (ported from Vim)
local utils = require('utils')

local cmd = vim.cmd

-- Tabs to spaces indent
local indent = 4

cmd 'syntax enable'

-- Turn on detection, plugin, and indent
-- `:help filetype-overview`
-- More help from https://vi.stackexchange.com/questions/10124/what-is-the-difference-between-filetype-plugin-indent-on-and-filetype-indent
cmd 'filetype plugin indent on'

-- As a reminder, for the below, 'b' is buffer scoped, 'o' is editor scoped, and 'w' is window scoped.

-- Convert tab to spaces on <Tab>
utils.opt('b','expandtab',true)

-- These are sorcery related to indentation... `:help` wasn't that useful
utils.opt('b','shiftwidth',indent)
utils.opt('b','tabstop',indent)

-- Converts tabs to spaces when using '<<' and '>>' while expandtab is enabled
utils.opt('b','autoindent',true)

-- Creates appropriate indentation on new lines
utils.opt('b','smartindent',true)

-- Automatic line wrapping for comments only. See `:h fo-table`
utils.opt('b','formatoptions','cq')

-- Print the line number in front of each line
utils.opt('w','number',true)

-- When the cursor is not on the line, use relative numbers
utils.opt('w','relativenumber',true)

-- Concealed text is hidden unless there is a custom replacement character (whatever that means)
utils.opt('w','conceallevel',2)


-- Highlight the line the cursor is on
utils.opt('w','cursorline',true)

-- Show the row and column number of the cursor
-- utils.opt('w','ruler',true)

utils.opt('o','encoding','utf-8')
utils.opt('o','history',500)

-- Fix backspace behaviors to 'normal'
utils.opt('o','backspace','indent,eol,start')

-- Configure use with the system clipboard
utils.opt('o','clipboard','unnamed,unnamedplus')

-- Height of the command area at the bottom of the buffer
-- Also prevents "Hit Enter" prompts
utils.opt('o','cmdheight',2)


-- When you leave an edited buffer, don't save it by default, just put it in the bufferlist in its current state
utils.opt('o', 'hidden', true)

-- Don't make sounds, flash the screen
utils.opt('o','visualbell',true)

-- Try to continuously read files in buffers even if they change outside neovim
utils.opt('o','autoread',true)

-- Try to avoid prompts to press enter
utils.opt('o','shortmess','a')

-- Use tab to autocomplete current highlight in autocommand menu.  Enable "enhanced" completion mode
utils.opt('o','wildmenu',true)

-- Complete to the longest common string, then the next full match, or if there is no common string complete the next full match after the last match
utils.opt('o','wildmode','longest:full,full')

-- Ignore case in searching unless capital letters are used
utils.opt('o','ignorecase',true)
utils.opt('o','smartcase',true)

-- When searching, highlight matches as they are found
utils.opt('o','incsearch',true)

-- When Searching, do not keep highlights
utils.opt('o','hlsearch',false)

-- Wrap text in buffers based on the window size
utils.opt('o','wrap',true)

-- Try to do line wrapping at word breaks rather than in the middle of a word
utils.opt('o','linebreak',true)

-- When wrapping text, wrapped lines keep the same indent as the preceding line
utils.opt('o','breakindent',true)

-- Let's don't do swap or backup or whatever for now
-- TODO swapfile is broken?
-- utils.opt('w','noswapfile',true)
-- utils.opt('o','backupdir','~/.vim/backup//')
-- utils.opt('o','directory','~/.vim/swap//')
-- utils.opt('o','undodir'  ,'~/.vim/undo//')

-- Maybe minimal is better than histogram or patience?
-- utils.opt('o','diffopt','vertical,context:3,foldcolumn:1,filler,algorithm:histogram,indent-heuristic')
utils.opt('o','diffopt','vertical,context:3,foldcolumn:1,filler,algorithm:minimal,indent-heuristic')


-- Where should new splits go?
utils.opt('o','splitright',true)
utils.opt('o','splitbelow',true)

-- The default for this is on, so I don't think we need it
-- utils.opt('o','showcmd',true)

-- Manipulate how long vim waits before assuming you're not using a keymap
utils.opt('o','ttimeout',true)
utils.opt('o','ttimeoutlen',10)
utils.opt('o','timeoutlen',500)

-- Keep at least 4 lines of text visible above the cursor
utils.opt('o','scrolloff',4)

-- Keep indents to be multiples of shiftwidth
utils.opt('o','shiftround',true)

utils.opt('o','tags','.git/tags')

-- For completion menus
vim.opt.completeopt={"menu","menuone","noselect"}
