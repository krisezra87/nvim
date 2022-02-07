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

let g:zet_dir = '~/.vimwiki/zettelkasten/' "Note that trailing slash is necessary
let g:zet_file_type = '.md' "Note that leading period is necessary

func! NewZettel()

  " build the file name
  let l:fname = g:zet_dir . strftime("%F-%H%M") . g:zet_file_type

  " edit the new file
  exec "e " . l:fname
  exec "normal ggOzet\<c-R>=UltiSnips#ExpandSnippetOrJump()\<CR>"
endfunc

command! Zet call NewZettel()

func! LinkedZettel()

  " build the file name
  let l:fname = g:zet_dir . strftime("%F-%H%M") . g:zet_file_type

  " Capture the name of the current file and clear everything up to the
  " vimwiki part since that is the base directory here
  let l:refName = fnamemodify(expand("%:p"), ":s?.*\.vimwiki/??")

  " Capture the title of the zettel (or whatever)
  exec "normal gg^wy$"

  " edit the new file
  exec "e " . l:fname
  exec "normal I[\<c-r>\"](../" . l:refName . ")"
  exec "normal ggOzet\<c-R>=UltiSnips#ExpandSnippetOrJump()\<CR>"
endfunc

command! Lzet call LinkedZettel()

" List and insert tags using fzf
" Search tags then search and open notes containing those tags
