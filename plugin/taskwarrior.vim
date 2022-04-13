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
    exec "normal /project\<cr>W"
    call s:projsearchreplace()
endfunc

command! FRP call FindReplaceProject()
" nnoremap <leader>tp :call FindReplaceProject()<cr>
nnoremap <leader>tp :FRP<cr>
