-- Define some global variables.  Is there a better way to do this to limit just to this file?
zet_dir = "~/.vimwiki/zettelkasten/"
diary_dir = "~/.vimwiki/diary/"
zet_ext = "md"

-- Enable searching through (and jumping to) existing zettels
_G.fzf_zettel_search = function(options)
    local fzf_lua = require'fzf-lua'
    options = options or {}
    options.prompt = "Zettels > "
    options.actions = {
        ['default'] = function(selected)
            choice = selected[1]:gsub(" ","_")
            vim.cmd("e " .. zet_dir .. choice .. ".md")
        end
    }
    options.cwd = zet_dir
    fzf_lua.fzf_exec([[fd -e ]] .. zet_ext .. [[ | sed 's/.*\///;s/\.md//;s/_/ /g']], options)
end

-- If ever I desire to get the preview window working
-- look into fzf's flag --nth, the default separator is : (configurable), you can include/exclude any field from the fuzzy matches while still keeping full paths in the display so the previewer can work.
vim.keymap.set('n','<leader>zz','<cmd> lua _G.fzf_zettel_search()<cr>')

--Link a zettel: Will do nothing if prompt doesn't match
_G.fzf_zettel_link = function(options)
    local fzf_lua = require'fzf-lua'
    options = options or {}
    options.prompt = "Zettels > "
    options.actions = {
        ['default'] = function(selected)
            name = selected[1]
            fstub = name:gsub(" ","_")
            vim.cmd('exec "normal a[[' .. fstub .. '|' .. name .. ']]"')
        end
    }
    options.cwd = zet_dir
    fzf_lua.fzf_exec([[fd -e ]] .. zet_ext .. [[ | sed 's/.*\///;s/\.md//;s/_/ /g']], options)
end

vim.keymap.set('n','<leader>zl','<cmd> lua _G.fzf_zettel_link()<cr>')

--Add an existing tag
_G.fzf_add_zettel_tag = function(options)
    local fzf_lua = require'fzf-lua'
    options = options or {}
    options.prompt = "Tags > "
    options.actions = {
        ['default'] = function(selected)
            -- If we completed the search go to the right place and put it in
            vim.cmd([[exec "normal gg/tags\<cr>$"]])
            local tag = nil
            if #selected > 0 then
                tag = selected[1]
            else
                tag = fzf_lua.config.__resume_data.last_query
                -- Put the search tag in double square brackets and replaces spaces with underscores since it's unlikely I've typed it this way
                tag = "[[" .. tag:gsub(" ","_") .. "]]"
            end

            vim.cmd('exec "normal a #' .. tag .. '"')
        end
    }
    options.cwd = zet_dir
    fzf_lua.fzf_exec([[rg -e '\s#[^, :]+' -g '*.]] .. zet_ext .. [[' -o --no-heading -I . | sed 's/\s.*#//' | sort | uniq]], options)
end

vim.keymap.set('n','<leader>zt','<cmd> lua _G.fzf_add_zettel_tag()<cr>')
vim.keymap.set('n','<leader>d',[[<cmd> lua require('fzf-lua').files({ cwd = ']] .. diary_dir ..[['})<cr>]])

-- Search tags then search and open notes containing those tags
