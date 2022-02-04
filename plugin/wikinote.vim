" For rapidly generating work notes
let g:note_dir = '~/.vimwiki/work_notes/'
let g:note_file_type = '.md' "Note that leading period is necessary

func! NoteEdit(...)

  " build the file name
    if len(a:000) > 0
        let l:fname = g:note_dir . join(a:000) . "/" . strftime("%F") . g:note_file_type
        " If the file doesn't exist, we will want to make an index entry
        if empty(glob(l:fname))
            let l:idxname = g:note_dir . join(a:000) . "/" . join(a:000) . g:note_file_type
            exec "e " . l:idxname
            exec "normal gg}olabel\<c-R>=UltiSnips#ExpandSnippetOrJump()\<CR>\<c-]>"
        endif
    else
        let l:fname = g:note_dir . strftime("%F") . g:note_file_type
    endif

  " edit the file
  if empty(glob(l:fname))
      exec "e " . l:fname
      exec "normal ggOnote\<c-R>=UltiSnips#ExpandSnippetOrJump()\<CR>"
  else
      exec "e " . l:fname
  endif
endfunc

command! -nargs=* Note call NoteEdit(<f-args>)
