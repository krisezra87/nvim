zet_dir = "~/.vimwiki/zettelkasten/"
notes_dir = "~/.vimwiki/notes/"
diary_dir = "~/.vimwiki/diary/"
zet_ext = "md"

-- Tracks the current book note being drawn from; set via <leader>zs, cleared via <leader>zS.
-- When set, all zettel creation commands inject it into ## References automatically.
active_source = nil

local function buffer_is_new()
    return vim.fn.line('$') == 1 and vim.fn.getline(1) == ""
end

local function write_zettel_template(title, opts)
    opts = opts or {}
    local date = os.date("%Y-%m-%d-%H%M")
    local links_block = opts.links or ""
    local refs_block = opts.refs
    if not refs_block and active_source then
        refs_block = "[[../" .. active_source.rel_path .. "|" .. active_source.title .. "]]\n"
    end
    refs_block = refs_block or ""

    local template = string.format([[
# %s

Date: %s
Tags:


## Links
%s
## References
%s]], title, date, links_block, refs_block)

    local lines = vim.split(template, "\n")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    -- Land cursor on body text area (line 6)
    vim.api.nvim_win_set_cursor(0, {6, 0})
end

-- :Zet — new zettel
vim.api.nvim_create_user_command("Zet", function(opts)
    local args = vim.split(opts.args, " ", { trimempty = true })
    local filename = table.concat(args, "_")
    local title = table.concat(args, " ")
    vim.cmd("e " .. vim.fn.expand(zet_dir) .. filename .. ".md")
    if buffer_is_new() then
        write_zettel_template(title)
    end
end, { nargs = "*" })

-- :ContZet — new zettel, inserting a forward link into current note's ## Links first
vim.api.nvim_create_user_command("ContZet", function(opts)
    local args = vim.split(opts.args, " ", { trimempty = true })
    local filename = table.concat(args, "_")
    local title = table.concat(args, " ")
    local link = "[[" .. filename .. "|" .. title .. "]]"

    -- Insert into ## Links of the current buffer
    -- nvim_buf_get_lines returns a 1-based Lua table; nvim_buf_set_lines takes 0-based indices.
    -- When links_line == i (1-based), 0-based insert position after the header is also i.
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for i, line in ipairs(lines) do
        if line:match("^##%s+[Ll]inks") then
            vim.api.nvim_buf_set_lines(0, i, i, false, { link })
            break
        end
    end

    vim.cmd("e " .. vim.fn.expand(zet_dir) .. filename .. ".md")
    if buffer_is_new() then
        write_zettel_template(title)
    end
end, { nargs = "*" })

-- :LinkLit — new zettel from a book note; source goes into ## References
vim.api.nvim_create_user_command("LinkLit", function(opts)
    local args = vim.split(opts.args, " ", { trimempty = true })
    local filename = table.concat(args, "_")
    local title = table.concat(args, " ")

    local cur_path = vim.fn.expand("%:p")
    local stem = cur_path:gsub(".*%.vimwiki/", ""):gsub("%.md$", "")   -- e.g. "notes/deep_work"
    local display = stem:match("[^/]+$"):gsub("_", " ")
    local ref_link = "[[../" .. stem .. "|" .. display .. "]]\n"

    vim.cmd("e " .. vim.fn.expand(zet_dir) .. filename .. ".md")
    if buffer_is_new() then
        write_zettel_template(title, { refs = ref_link })
    end
end, { nargs = "*" })

-- :LinkZet — new zettel with a back-link to the current zettel in ## Links
vim.api.nvim_create_user_command("LinkZet", function(opts)
    local args = vim.split(opts.args, " ", { trimempty = true })
    local filename = table.concat(args, "_")
    local title = table.concat(args, " ")
    local cur_stem = vim.fn.expand("%:t:r")
    local cur_title = cur_stem:gsub("_", " ")
    local back_link = "[[" .. cur_stem .. "|" .. cur_title .. "]]\n"

    vim.cmd("e " .. vim.fn.expand(zet_dir) .. filename .. ".md")
    if buffer_is_new() then
        write_zettel_template(title, { links = back_link })
    end
end, { nargs = "*" })

-- :ZI — jump to zettel index
vim.api.nvim_create_user_command("ZI", function()
    vim.cmd("e ~/.vimwiki/zettelkasten/zettel_index.md")
end, {})

-- Helpers shared by all file pickers
local zet_dir_abs = vim.fn.expand(zet_dir)

-- Entries are titles only ("deep work", "attention residue").
-- The preview reconstructs the filename via shell substitution: {} → title → stem.md
local zettel_list_cmd = "fd -e " .. zet_ext .. [[ | sed 's/.*\///;s/\.md//;s/_/ /g']]

local zettel_fzf_opts = {
    ['--preview'] = "bat --color=always --style=plain " .. zet_dir_abs .. "$(echo {} | tr ' ' '_').md",
}

local function open_zettel(entry)
    vim.cmd("e " .. zet_dir .. entry:gsub(" ", "_") .. ".md")
end

-- FZF: search and open a zettel
_G.fzf_zettel_search = function(options)
    local fzf_lua = require'fzf-lua'
    options = options or {}
    options.prompt    = "Zettels > "
    options.cwd       = zet_dir
    options.fzf_opts  = zettel_fzf_opts
    options.actions   = { ['default'] = function(sel) open_zettel(sel[1]) end }
    fzf_lua.fzf_exec(zettel_list_cmd, options)
end

vim.keymap.set('n', '<leader>zz', '<cmd>lua _G.fzf_zettel_search()<cr>')
vim.keymap.set('n', '<leader>z',  '<cmd>ZI<cr>')

-- FZF: insert a wikilink to a zettel
_G.fzf_zettel_link = function(options)
    local fzf_lua = require'fzf-lua'
    options = options or {}
    options.prompt   = "Zettels > "
    options.cwd      = zet_dir
    options.fzf_opts = zettel_fzf_opts
    options.actions  = {
        ['default'] = function(sel)
            local title = sel[1]
            local fname = title:gsub(" ", "_")
            vim.cmd('exec "normal a[[' .. fname .. '|' .. title .. ']]"')
        end
    }
    fzf_lua.fzf_exec(zettel_list_cmd, options)
end

vim.keymap.set('n', '<leader>zl', '<cmd>lua _G.fzf_zettel_link()<cr>')

-- FZF: pick an existing tag and insert it into the current note's Tags line
_G.fzf_add_zettel_tag = function(options)
    local fzf_lua = require'fzf-lua'
    options = options or {}
    options.prompt = "Tags > "
    options.actions = {
        ['default'] = function(selected)
            vim.cmd([[exec "normal gg/tags\<cr>$"]])
            local tag
            if #selected > 0 then
                tag = selected[1]
            else
                tag = fzf_lua.config.__resume_data.last_query
                tag = "[[" .. tag:gsub(" ", "_") .. "]]"
            end
            vim.cmd('exec "normal a #' .. tag .. '"')
        end
    }
    options.cwd = zet_dir
    fzf_lua.fzf_exec([[rg -e '\s#[^, :]+' -g '*.]] .. zet_ext .. [[' -o --no-heading -I . | sed 's/\s.*#//' | sort | uniq]], options)
end

vim.keymap.set('n', '<leader>zt', '<cmd>lua _G.fzf_add_zettel_tag()<cr>')

-- FZF: pick a notes/ file as the active source for this session
_G.fzf_set_active_source = function()
    local fzf_lua = require'fzf-lua'
    local notes_abs = vim.fn.expand(notes_dir)

    -- Build "stub: Title" entries by reading the H1 from each file in Lua
    local entries = {}
    local files = vim.fn.glob(notes_abs .. "*.md", false, true)
    table.sort(files)
    for _, path in ipairs(files) do
        local stub = vim.fn.fnamemodify(path, ":t:r")
        local f = io.open(path, "r")
        if f then
            local first_line = f:read("*l")
            f:close()
            local title = (first_line and first_line:match("^# (.+)")) or stub:gsub("_", " ")
            entries[#entries + 1] = stub .. ": " .. title
        end
    end

    fzf_lua.fzf_exec(entries, {
        prompt = "Source > ",
        fzf_opts = {
            -- stub is always the first colon-delimited token; no spaces so cut -d: -f1 is safe
            ['--preview'] = "bat --color=always --style=plain " .. notes_abs .. "$(echo {} | cut -d: -f1).md",
        },
        actions = {
            ['default'] = function(selected)
                local entry = selected[1]
                local stub  = entry:match("^([^:]+):")
                local title = entry:match("^[^:]+:%s*(.+)$")
                if stub then
                    active_source = { stub = stub, title = title, rel_path = "notes/" .. stub }
                    vim.notify("Active source: " .. title)
                end
            end
        }
    })
end

-- Stamp active source into ## References of the current buffer
_G.stamp_active_source = function()
    if not active_source then
        vim.notify("No active source set", vim.log.levels.WARN)
        return
    end
    local link = "[[../" .. active_source.rel_path .. "|" .. active_source.title .. "]]"
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for i, line in ipairs(lines) do
        if line:match("^##%s+[Rr]eferences") then
            vim.api.nvim_buf_set_lines(0, i, i, false, { link })
            return
        end
    end
    vim.notify("No ## References section found", vim.log.levels.WARN)
end

vim.keymap.set('n', '<leader>zs', '<cmd>lua _G.fzf_set_active_source()<cr>')
vim.keymap.set('n', '<leader>zS', function()
    active_source = nil
    vim.notify("Active source cleared")
end)
vim.keymap.set('n', '<leader>zr', '<cmd>lua _G.stamp_active_source()<cr>')

-- FZF: show all zettels that link to the current file (backlinks)
_G.fzf_zettel_backlinks = function(options)
    local fzf_lua = require'fzf-lua'
    local stem = vim.fn.expand("%:t:r")
    if stem == "" then
        vim.notify("No file open", vim.log.levels.WARN)
        return
    end
    local cmd = "rg --files-with-matches " .. vim.fn.shellescape(stem)
                .. " -g '*." .. zet_ext .. "' | sed 's/.*\\///;s/\\.md//;s/_/ /g'"
    options = options or {}
    options.prompt   = "Backlinks > "
    options.cwd      = zet_dir
    options.fzf_opts = zettel_fzf_opts
    options.actions  = { ['default'] = function(sel) open_zettel(sel[1]) end }
    fzf_lua.fzf_exec(cmd, options)
end

vim.keymap.set('n', '<leader>zb', '<cmd>lua _G.fzf_zettel_backlinks()<cr>')

-- FZF two-step tag search: pick a tag, then browse notes containing it
_G.fzf_zettel_tag_search = function(options)
    local fzf_lua = require'fzf-lua'
    options = options or {}
    options.prompt = "Tags > "
    options.cwd    = zet_dir
    options.actions = {
        ['default'] = function(selected)
            local tag = #selected > 0 and selected[1] or fzf_lua.config.__resume_data.last_query
            local cmd = "rg --files-with-matches " .. vim.fn.shellescape("#" .. tag)
                        .. " -g '*." .. zet_ext .. "' | sed 's/.*\\///;s/\\.md//;s/_/ /g'"
            fzf_lua.fzf_exec(cmd, {
                prompt   = "Notes[" .. tag .. "] > ",
                cwd      = zet_dir,
                fzf_opts = zettel_fzf_opts,
                actions  = { ['default'] = function(sel) open_zettel(sel[1]) end },
            })
        end
    }
    fzf_lua.fzf_exec([[rg -e '\s#[^, :]+' -g '*.]] .. zet_ext .. [[' -o --no-heading -I . | sed 's/\s.*#//' | sort | uniq]], options)
end

vim.keymap.set('n', '<leader>zT', '<cmd>lua _G.fzf_zettel_tag_search()<cr>')

vim.keymap.set('n', '<leader>d', [[<cmd>lua require('fzf-lua').files({ cwd = ']] .. diary_dir .. [['})<cr>]])

-- VimWiki maps <BS> to its own nav stack, which only tracks Enter-followed links.
-- Zettel commands open files via :e, bypassing that stack. Remap to <C-o> so the
-- native jumplist (populated by all :e calls) handles back-navigation instead.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "vimwiki",
    callback = function()
        vim.keymap.set('n', '<BS>', '<C-o>', { buffer = true })
    end,
})
