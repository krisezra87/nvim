-- Util functions for managing scope and mappings
local utils = {}

-- logic for the below can be found with `:h lua-vim-variables`
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

-- This function manages scope arguments
function utils.opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

-- This function is used for key mappings
function utils.map(mode, lhs, rhs, opts)
    -- Default to noremap if no options specified
    local options = {noremap = true}
    if opts then options=vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

return utils
