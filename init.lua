-- LUA base configuration file
-- Modified from: https://alpha2phi.medium.com/neovim-init-lua-e80f4f136030

-- Set up interoperability with VimL
local fn = vim.fn
local execute = vim.api.nvim_command

-- For nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Configure leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Include plugins
require('plugins')

require('lsp')
require('fzf-config')

-- Add preferred defaults
require('settings')


-- Core key mappings
require('corekeymaps')


require('config.colorscheme') -- colorscheme additional setup

-- More precise folding
-- See https://github.com/nvim-treesitter/nvim-treesitter/issues/860
-- and
-- https://www.reddit.com/r/neovim/comments/k7ftqv/treesitter_folding_python/

-- Put in restart configurations for some programs
require('restart_configs')

-- Try to remove error about detecting DSR for st
vim.o.ttimeoutlen = 10
if vim.env.TERM and vim.env.TERM:match('st') then
  vim.o.termguicolors = true
end
