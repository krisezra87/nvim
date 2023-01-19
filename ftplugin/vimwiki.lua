_G.make_diary_links = function(query)
    -- ls | grep 2023-01- | xargs grep -H '^# ' | awk -F:# '{print "[["$1"]] -"$2}'
    -- TODO Need a variable for the path to the diary or this won't work
    local tmp1 = ([[exec "r !ls | grep %s]]):format(query)
    local tmp2 = [[ | xargs grep -H '^\\# ']]
    local tmp3 = [[ | awk -F:\\# '{print ]] .. [[\"\[\[\"$1 \"\]\] -\"]] .. [[ $2}']]
    local tmp4 = '"'
    local tmp = tmp1 .. tmp2 .. tmp3 .. tmp4
    vim.cmd(tmp)
end

--Make it a named command so it can be called from the command line
vim.cmd([[command! -nargs=* MakeDiaryLinks lua _G.make_diary_links(<f-args>)]])

vim.api.nvim_create_user_command(
    'Upper',
    function(opts)
        read(string.upper(opts.args))
    end,
    { nargs = 1 }
)
