-- Replace a project title with a new one for taskwarrior
_G.fzf_project_replace = function()
    -- First get us in the right place in the taskwarrior task file
    vim.cmd([[exec "normal gg/description\<cr>zt?project\<cr>W"]])
    local fzf_lua = require'fzf-lua'
    options = {}
    options.prompt = "Projects > "
    options.winopts = { height=.6, width=0.8, row = 0.5 }
    options.actions = {
        ['default'] = function(selected)
            project = nil
            if #selected > 0 then
                project = selected[1]
            else
                project = fzf_lua.config.__resume_data.last_query
            end
            -- It seems to take us out of insert automagically, and doesn't
            -- even require a call to "exec" so just do the change
            vim.cmd([[normal ciW]] .. project)
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
    local fzf_lua = require'fzf-lua'
    options = {}
    options.prompt = "Tags > "
    options.winopts = { height=.6, width=0.8, row = 0.5 }
    options.actions = {
        ['default'] = function(selected)
            -- removed a `gg` before /tags because this is generally run after
            -- project search and it messes up screen position
            vim.cmd([[exec "normal /Tags\<cr>$"]])
            tag = nil
            if #selected > 0 then
                tag = selected[1]
            else
                tag = fzf_lua.config.__resume_data.last_query
            end
            -- It seems to take us out of insert automagically, and doesn't
            -- even require a call to "exec" so just do the change
            vim.cmd([[normal a ]] .. tag)
        end
    }
    --Make the call to get the projects
    fzf_lua.fzf_exec("task _tags | awk '! /^[[:space:][:upper:]]*$/'", options)
end

--Create a leader mapping
vim.keymap.set('n','<leader>tt','<cmd> lua _G.fzf_add_tag()<cr>')
