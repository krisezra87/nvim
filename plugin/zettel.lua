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
%s
## Open Questions
]], title, date, links_block, refs_block)

    local lines = vim.split(template, "\n")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    -- Land cursor on body text area (line 6)
    vim.api.nvim_win_set_cursor(0, {6, 0})
end

-- :Zet — new zettel; splits vertically when originating from a notes file so the
-- source stays visible and auto-injects it into ## References, otherwise edits in place
vim.api.nvim_create_user_command("ZetNew", function(opts)
    local args = vim.split(opts.args, " ", { trimempty = true })
    local filename = table.concat(args, "_")
    local title = table.concat(args, " ")
    local target = vim.fn.expand(zet_dir) .. filename .. ".md"
    local notes_abs = vim.fn.expand(notes_dir)
    local from_notes = vim.fn.expand("%:p"):find(notes_abs, 1, true)
    local template_opts = {}
    if from_notes then
        local stub = vim.fn.expand("%:t:r")
        local note_title = vim.fn.getline(1):match("^# (.+)") or stub:gsub("_", " ")
        template_opts.refs = "[[../notes/" .. stub .. "|" .. note_title .. "]]\n"
    end
    vim.cmd((from_notes and "vs " or "e ") .. target)
    if buffer_is_new() then
        write_zettel_template(title, template_opts)
    end
end, { nargs = "*" })

-- :ZetCont — new zettel, inserting a forward link into current note's ## Links first
vim.api.nvim_create_user_command("ZetCont", function(opts)
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


-- :ZetIndex — jump to zettel index
vim.api.nvim_create_user_command("ZetIndex", function()
    vim.cmd("e ~/.vimwiki/zettelkasten/zettel_index.md")
end, {})

-- :ZetSummary — run from a notes/ file; opens a scratch buffer listing all zettels
-- that reference it via ## References, sorted chronologically by their Date field.
vim.api.nvim_create_user_command("ZetSummary", function()
    local cur_path = vim.fn.expand("%:p")
    local notes_abs = vim.fn.expand(notes_dir)
    local zet_abs   = vim.fn.expand(zet_dir)

    if not cur_path:find(notes_abs, 1, true) then
        vim.notify("ZetSummary must be run from a notes/ file", vim.log.levels.WARN)
        return
    end

    local stem  = vim.fn.expand("%:t:r")
    local title = vim.fn.getline(1):match("^# (.+)") or stem:gsub("_", " ")

    -- Find all zettels that contain a link back to this notes file
    local paths = vim.fn.systemlist(
        "rg --files-with-matches " .. vim.fn.shellescape("notes/" .. stem)
        .. " -g '*." .. zet_ext .. "' " .. vim.fn.shellescape(zet_abs)
    )

    if #paths == 0 then
        vim.notify("No zettels reference " .. stem, vim.log.levels.INFO)
        return
    end

    -- Read H1 title and Date from each zettel
    local zettels = {}
    for _, path in ipairs(paths) do
        local zstub  = vim.fn.fnamemodify(path, ":t:r")
        local ztitle = zstub:gsub("_", " ")
        local date   = ""
        local f = io.open(path, "r")
        if f then
            for line in f:lines() do
                if line:match("^# ") then
                    ztitle = line:match("^# (.+)") or ztitle
                elseif line:match("^Date:") then
                    date = line:match("^Date:%s*(.+)") or ""
                    break
                end
            end
            f:close()
        end
        zettels[#zettels + 1] = { date = date, stub = zstub, title = ztitle }
    end

    -- Sort chronologically (YYYY-MM-DD-HHMM is lexicographically sortable)
    table.sort(zettels, function(a, b) return a.date < b.date end)

    -- Build scratch buffer lines
    local lines = { "# " .. title .. " — linked zettels", "" }
    for _, z in ipairs(zettels) do
        lines[#lines + 1] = "[[" .. z.stub .. "|" .. z.title .. "]]  " .. z.date
    end

    -- Open in a horizontal split as a read-only vimwiki scratch buffer.
    -- Naming the buffer inside the zettelkasten directory lets vimwiki resolve
    -- [[wikilinks]] correctly when following them with <CR>.
    vim.cmd("new")
    vim.bo.buftype   = "nofile"
    vim.bo.bufhidden = "wipe"
    vim.bo.swapfile  = false
    vim.api.nvim_buf_set_name(0, zet_abs .. "_ZetSummary.md")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.bo.filetype   = "vimwiki"
    vim.bo.modifiable = false
end, {})

-- :ZetRename — rename current zettel file + update all [[old_stem links across zettelkasten
vim.api.nvim_create_user_command("ZetRename", function()
    local cur_path = vim.fn.expand("%:p")
    local zet_abs  = vim.fn.expand(zet_dir)

    if not cur_path:find(zet_abs, 1, true) then
        vim.notify("ZetRename must be run from a zettelkasten file", vim.log.levels.WARN)
        return
    end

    local old_stem  = vim.fn.expand("%:t:r")
    local old_title = old_stem:gsub("_", " ")
    local new_input = vim.fn.input("Rename to: ", old_title)
    vim.cmd("redraw")
    if new_input == "" or new_input == old_title then return end

    local new_stem  = new_input:gsub(" ", "_")
    local new_path  = zet_abs .. new_stem .. "." .. zet_ext

    if vim.fn.filereadable(new_path) == 1 then
        vim.notify("Already exists: " .. new_stem .. ".md", vim.log.levels.ERROR)
        return
    end

    -- Update H1 before rename so the corrected content is what gets moved
    local first = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    if first == "# " .. old_title then
        vim.api.nvim_buf_set_lines(0, 0, 1, false, { "# " .. new_input })
    end
    vim.cmd("silent! write")

    if vim.fn.rename(cur_path, new_path) ~= 0 then
        vim.notify("Rename failed", vim.log.levels.ERROR)
        return
    end

    -- Replace all [[old_stem occurrences across zettelkasten
    local sed_expr = "s/\\[\\[" .. old_stem .. "/[[" .. new_stem .. "/g"
    local rg_cmd = "rg --files-with-matches " .. vim.fn.shellescape("\\[\\[" .. old_stem)
                   .. " -g '*." .. zet_ext .. "' " .. vim.fn.shellescape(zet_abs)
                   .. " | xargs -r sed -i " .. vim.fn.shellescape(sed_expr)
    vim.fn.system(rg_cmd)

    -- Also update display text when it exactly matches the old title (stem with spaces)
    if old_title ~= new_input then
        local sed_disp = "s/\\[\\[" .. new_stem .. "|" .. old_title .. "\\]\\]/[[" .. new_stem .. "|" .. new_input .. "]]/g"
        local rg_disp = "rg --files-with-matches " .. vim.fn.shellescape("\\[\\[" .. new_stem .. "\\|" .. old_title)
                        .. " -g '*." .. zet_ext .. "' " .. vim.fn.shellescape(zet_abs)
                        .. " | xargs -r sed -i " .. vim.fn.shellescape(sed_disp)
        vim.fn.system(rg_disp)
    end

    -- Point the current buffer at the new path (VimWiki autocmds may reload from disk,
    -- which is fine — the file already has the updated H1)
    vim.cmd("file " .. vim.fn.fnameescape(new_path))
    vim.notify("Renamed: " .. old_stem .. " → " .. new_stem)
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

-- :ZetOpenLoops — find zettels with non-empty ## Open Questions sections
vim.api.nvim_create_user_command("ZetOpenLoops", function()
    local fzf_lua = require'fzf-lua'
    local zet_abs = vim.fn.expand(zet_dir)
    local files = vim.fn.glob(zet_abs .. "*." .. zet_ext, false, true)
    local matches = {}

    for _, path in ipairs(files) do
        local f = io.open(path, "r")
        if f then
            local in_section = false
            for line in f:lines() do
                if line:match("^## Open Questions") then
                    in_section = true
                elseif in_section then
                    if line:match("^##") then break end
                    if line:match("%S") then
                        matches[#matches + 1] = vim.fn.fnamemodify(path, ":t:r"):gsub("_", " ")
                        break
                    end
                end
            end
            f:close()
        end
    end

    if #matches == 0 then
        vim.notify("No open loops found", vim.log.levels.INFO)
        return
    end

    fzf_lua.fzf_exec(matches, {
        prompt   = "Open Loops > ",
        fzf_opts = zettel_fzf_opts,
        actions  = { ['default'] = function(sel) open_zettel(sel[1]) end },
    })
end, {})

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
vim.keymap.set('n', '<leader>z',  '<cmd>ZetIndex<cr>')

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

-- Shared picker over notes/ files; calls on_select(stub, title) on confirmation
local function notes_picker(prompt, on_select)
    local fzf_lua = require'fzf-lua'
    local notes_abs = vim.fn.expand(notes_dir)
    local entries = {}
    local files = vim.fn.glob(notes_abs .. "*.md", false, true)
    table.sort(files)
    for _, path in ipairs(files) do
        local stub = vim.fn.fnamemodify(path, ":t:r")
        if stub == "book_index" then goto continue end
        local f = io.open(path, "r")
        if f then
            local first_line = f:read("*l")
            f:close()
            local title = (first_line and first_line:match("^# (.+)")) or stub:gsub("_", " ")
            entries[#entries + 1] = stub .. ": " .. title
        end
        ::continue::
    end
    fzf_lua.fzf_exec(entries, {
        prompt    = prompt,
        fzf_opts  = {
            ['--preview'] = "bat --color=always --style=plain " .. notes_abs .. "$(echo {} | cut -d: -f1).md",
        },
        actions = {
            ['default'] = function(selected)
                local stub  = selected[1]:match("^([^:]+):")
                local title = selected[1]:match("^[^:]+:%s*(.+)$")
                if stub then on_select(stub, title) end
            end
        }
    })
end

-- Insert a reference link into ## References of the current buffer
local function stamp_reference(stub, title)
    local link = "[[../notes/" .. stub .. "|" .. title .. "]]"
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for i, line in ipairs(lines) do
        if line:match("^##%s+[Rr]eferences") then
            vim.api.nvim_buf_set_lines(0, i, i, false, { link })
            return
        end
    end
    vim.notify("No ## References section found", vim.log.levels.WARN)
end

-- <leader>zn — browse and open a notes/ file
vim.keymap.set('n', '<leader>zn', function()
    notes_picker("Notes > ", function(stub, _)
        vim.cmd("e " .. vim.fn.expand(notes_dir) .. stub .. ".md")
    end)
end)

-- <leader>zs — set active source from current file when in notes/, picker otherwise
vim.keymap.set('n', '<leader>zs', function()
    local notes_abs = vim.fn.expand(notes_dir)
    if vim.fn.expand("%:p"):find(notes_abs, 1, true) then
        local stub  = vim.fn.expand("%:t:r")
        local title = vim.fn.getline(1):match("^# (.+)") or stub:gsub("_", " ")
        active_source = { stub = stub, title = title, rel_path = "notes/" .. stub }
        vim.notify("Active source: " .. title)
    else
        notes_picker("Source > ", function(stub, title)
            active_source = { stub = stub, title = title, rel_path = "notes/" .. stub }
            vim.notify("Active source: " .. title)
        end)
    end
end)

-- <leader>zS — clear active source
vim.keymap.set('n', '<leader>zS', function()
    active_source = nil
    vim.notify("Active source cleared")
end)

-- <leader>zr — stamp active source into ## References
vim.keymap.set('n', '<leader>zr', function()
    if not active_source then
        vim.notify("No active source set", vim.log.levels.WARN)
        return
    end
    stamp_reference(active_source.stub, active_source.title)
end)

-- <leader>zR — pick any notes file and stamp it into ## References (one-shot, no state change)
vim.keymap.set('n', '<leader>zR', function()
    notes_picker("Reference > ", stamp_reference)
end)

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
            local raw = #selected > 0 and selected[1] or fzf_lua.config.__resume_data.last_query
            local label = raw:match("^%[%[(.-)%]%]$") or raw
            local cmd = "rg -F --files-with-matches " .. vim.fn.shellescape("#" .. raw)
                        .. " -g '*." .. zet_ext .. "' | sed 's/.*\\///;s/\\.md//;s/_/ /g'"
            fzf_lua.fzf_exec(cmd, {
                prompt   = "Notes[" .. label .. "] > ",
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

-- Passive backlink virtual lines: shown below the buffer on BufEnter, cleared on BufLeave
local backlink_ns = vim.api.nvim_create_namespace("zettel_backlinks")

local function update_backlinks(buf)
    vim.api.nvim_buf_clear_namespace(buf, backlink_ns, 0, -1)
    local path = vim.api.nvim_buf_get_name(buf)
    local zet_abs = vim.fn.expand(zet_dir)
    if not path:find(zet_abs, 1, true) then return end
    local stem = path:match("([^/]+)%.[^.]+$")
    if not stem or stem == "" then return end

    vim.system(
        { "rg", "-F", "--files-with-matches", "[[" .. stem, "-g", "*." .. zet_ext, zet_abs },
        { text = true },
        vim.schedule_wrap(function(result)
            if not result.stdout or result.stdout == "" then return end
            local names = {}
            for _, f in ipairs(vim.split(vim.trim(result.stdout), "\n")) do
                if f ~= "" then
                    local s = f:match("([^/]+)%.[^.]+$")
                    if s then names[#names + 1] = s:gsub("_", " ") end
                end
            end
            if #names == 0 then return end
            if not vim.api.nvim_buf_is_valid(buf) then return end
            local line_count = vim.api.nvim_buf_line_count(buf)
            local virt = { { { "", "Comment" } }, { { "## Back Links", "Comment" } } }
            for _, name in ipairs(names) do
                virt[#virt + 1] = { { "← " .. name, "Comment" } }
            end
            vim.api.nvim_buf_set_extmark(buf, backlink_ns, line_count - 1, 0, {
                virt_lines = virt,
            })
        end)
    )
end

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.md",
    callback = function() update_backlinks(vim.api.nvim_get_current_buf()) end,
})

vim.api.nvim_create_autocmd("BufLeave", {
    pattern = "*.md",
    callback = function()
        vim.api.nvim_buf_clear_namespace(vim.api.nvim_get_current_buf(), backlink_ns, 0, -1)
    end,
})

-- VimWiki maps <BS> to its own nav stack, which only tracks Enter-followed links.
-- Zettel commands open files via :e, bypassing that stack. Remap to <C-o> so the
-- native jumplist (populated by all :e calls) handles back-navigation instead.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "vimwiki",
    callback = function()
        vim.keymap.set('n', '<BS>', '<C-o>', { buffer = true })
    end,
})
