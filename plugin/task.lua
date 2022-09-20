-- Replace a project title with a new one for taskwarrior
_G.fzf_project_replace = function()
    -- First get us in the right place in the taskwarrior task file
    vim.cmd([[exec "normal gg/project\<cr>ztW"]])
    local fzf_lua = require'fzf-lua'
    options = {}
    options.prompt = "Projects > "
    options.actions = {
        ['default'] = function(selected)
            choice = selected[1]
            -- It seems to take us out of insert automagically, and doesn't
            -- even require a call to "exec" so just do the change
            vim.cmd([[normal ciW]] .. choice)
        end
    }
    --Make the call to get the projects
    fzf_lua.fzf_exec("task _projects", options)
end

--Create a leader mapping
vim.keymap.set('n','<leader>tp','<cmd> lua _G.fzf_project_replace()<cr>')

--Make it a named command so it can be called from the command line
vim.cmd([[command! FPR lua _G.fzf_project_replace()]])


-- Replace a project title with a new one for taskwarrior
_G.fzf_add_tag = function()
    -- First get us in the right place in the taskwarrior task file
    vim.cmd([[exec "normal gg/Tags\<cr>zt$"]])
    local fzf_lua = require'fzf-lua'
    options = {}
    options.prompt = "Tags > "
    options.actions = {
        ['default'] = function(selected)
            choice = selected[1]
            -- It seems to take us out of insert automagically, and doesn't
            -- even require a call to "exec" so just do the change
            vim.cmd([[normal a ]] .. choice)
        end
    }
    --Make the call to get the projects
    fzf_lua.fzf_exec("task _tags | awk '! /^[[:space:][:upper:]]*$/'", options)
end

--Create a leader mapping
vim.keymap.set('n','<leader>tt','<cmd> lua _G.fzf_add_tag()<cr>')
