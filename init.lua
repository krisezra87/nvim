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

-- Add preferred defaults
require('settings')

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

-- Core key mappings
require('corekeymaps')

-- Include plugins
require('plugins')

require('config.colorscheme') -- colorscheme additional setup

-- More precise folding
-- See https://github.com/nvim-treesitter/nvim-treesitter/issues/860
-- and
-- https://www.reddit.com/r/neovim/comments/k7ftqv/treesitter_folding_python/

-- Put in restart configurations for some programs
require('restart_configs')
