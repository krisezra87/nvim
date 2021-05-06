-- LUA base configuration file
-- Modified from: https://alpha2phi.medium.com/neovim-init-lua-e80f4f136030

-- Set up interoperability with VimL
local fn = vim.fn
local execute = vim.api.nvim_command

-- Configure leader
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

-- Add preferred defaults
require('settings')

-- Auto install packer.nvim if it doesn't exist
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end
vim.cmd [[packadd packer.nvim]]
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

-- Core key mappings
require('corekeymaps')
