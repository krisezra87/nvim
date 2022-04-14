" Some niceties for working with the taskwarrior task list
func! s:projsearchreplace()
    call fzf#run({
                \ 'source': "task _projects",
                \ 'sink': function('ReplaceProject'),
                \ 'down': '30%',
                \ 'options': "--print-query",
                \})
endfunc

func! ReplaceProject(...)
    exec "normal ciW" . a:000[-1] . "\<c-]>"
endfunc

func! FindReplaceProject()
    exec "normal /project\<cr>ztW"
    call s:projsearchreplace()
endfunc

command! FRP call FindReplaceProject()
" nnoremap <leader>tp :call FindReplaceProject()<cr>
nnoremap <leader>tp :FRP<cr>

func! s:tagadd()
    " Source is tags, then use awk to remove tags which are all uppercase.
    " These are likely virtual tags.  Buyer beware
    " \ 'source': "task _tags",
    call fzf#run({
                \ 'source': "task _tags \| awk '! /^[[:space:][:upper:]]*$/'",
                \ 'sink': function('AddTag'),
                \ 'down': '30%',
                \ 'options': "--print-query",
                \})
endfunc

func! FindAddTag()
    exec "normal /Tags\<cr>zt$"
    " Something weird is happening here where I think the call to fzf actually
    " calls AddTag twice in tagadd.  By using ciw we just overwrite, but it's still
    " hacky AF
    exec "normal atemp\<c-]>"
    call s:tagadd()
    " exec "normal a \<c-]>" " this causes an error E349 No identifier under
    " cursor
endfunc

func! AddTag(...)
    exec "normal ciw" . a:000[-1] . "\<c-]>"
endfunc

command! AddAdditionalTag call FindAddTag()
nnoremap <leader>tt :AddAdditionalTag<cr>
