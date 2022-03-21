" For rapidly generating work notes
let g:note_dir = '~/work_notes/'
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

func! NewZettel(...)

    " build the file name
    let l:fname = g:zet_dir . join(a:000,'_') . g:zet_file_type

    " edit the new file
    exec "e " . l:fname
    exec "normal ggOzet\<c-R>=UltiSnips#ExpandSnippetOrJump()\<CR>"
endfunc

command! -nargs=* Zet call NewZettel(<f-args>)

func! LinkedLit(...)
    " Create a new zettel from a literature note in a diary

    " build the file name
    let l:fname = g:zet_dir . substitute(join(a:000),' ','_','g') . g:zet_file_type

    " Capture the name of the current file and clear everything up to the
    " vimwiki part since that is the base directory here
    let l:refName = fnamemodify(expand("%:p"), ":s?.*\.vimwiki/??")

    " Capture the title of the zettel (or whatever)
    exec "normal gg^wy$"

    " edit the new file and link the literature note as a reference
    exec "vs " . l:fname
    exec "normal I[\<c-r>\"](../" . l:refName . ")"
    exec "normal ggOzet\<c-R>=UltiSnips#ExpandSnippetOrJump()\<CR>"
endfunc

command! -nargs=* LinkLit call LinkedLit(<f-args>)

func! LinkedZet(...)
    " Create a new zettel linked to existing zettel

    " build the file name
    let l:fname = g:zet_dir . substitute(join(a:000),' ','_','g') . g:zet_file_type

    " Capture the name of the current file
    let l:refName = expand("%:t:r")

    " edit the new file and create the link
    exec "e " . l:fname
    exec "normal ggOzettail\<c-R>=UltiSnips#ExpandSnippetOrJump()\<CR>"
    exec "normal G?link\<CR>o[[" . l:refName . "]]\<c-]>"
    exec "normal ggOzethead\<c-R>=UltiSnips#ExpandSnippetOrJump()\<CR>"
endfunc

command! -nargs=* LinkZet call LinkedZet(<f-args>)

func! ContinueZet(...)
    " Create a new zettel but put the link to it in the current zettel

    " build the file name
    let l:fname = g:zet_dir . substitute(join(a:000),' ','_','g') . g:zet_file_type

    " Link it in this file
    exec "normal G?##.links\<CR>}O[[" . substitute(join(a:000),' ','_','g') . "\|" . join(a:000) . "]]\<c-]>"

    " edit the new file and create the link
    exec "e " . l:fname
    exec "normal ggOzet\<c-R>=UltiSnips#ExpandSnippetOrJump()\<CR>"
    " If we wanted to insert a back link, this is the way below instead of the
    " above line
    " exec "normal ggOzettail\<c-R>=UltiSnips#ExpandSnippetOrJump()\<CR>"
    " exec "normal G?link\<CR>o[[" . l:refName . "]]\<c-]>"
    " exec "normal ggOzethead\<c-R>=UltiSnips#ExpandSnippetOrJump()\<CR>"
endfunc

command! -nargs=* ContZet call ContinueZet(<f-args>)

" Open a zettel
func! s:fzfzettels()
    call fzf#run({
                \ 'source': "rg --files -g '*.md' " . g:zet_dir . "\| sed 's/.*\\///;s/\.md//;s/_/ /g'",
                \ 'sink': function('OpenLink'),
                \ 'down': '30%'
                \})
endfunc

func! OpenLink(...)
    exec "e " . g:zet_dir . substitute(join(a:000),' ','_','g') . ".md"
endfunc

command! ZettelOpen call s:fzfzettels()
nnoremap <leader>zz :ZettelOpen<cr>


" List and insert file links with fzf
func! s:fzfzettellink()
    call fzf#run({
                \ 'source': "rg --files -g '*.md' " . g:zet_dir . "\| sed 's/.*\\///;s/\.md//;s/_/ /g'",
                \ 'sink': function('InsertLink'),
                \ 'down': '30%'
                \})
endfunc

func! InsertLink(...)
    exec "normal a[[" . substitute(join(a:000),' ','_','g') . "\|" . join(a:000) . "]]\<c-]>"
endfunc


command! ZettelLink call s:fzfzettellink()
nnoremap <leader>zl :ZettelLink<cr>

func! InsertTag(...)
    exec "normal a#" . join(a:000) . " \<c-]>"
    " Delete weird spacing inserted and jump to end of line
endfunc

func! s:fzfzetteltags()
    "rg -e '\s#[^, :]+' -g '*.md' -o --no-heading -I . | sed 's/#//' | sort | uniq

    call fzf#run({
                \ 'source': "rg -e '#[^, :#\\n]+' -g '*.md' -o --no-heading -I " . g:zet_dir . "\| sed 's/#//' \| sort \| uniq",
                \ 'sink': function('InsertTag'),
                \ 'down': '30%'
                \})
endfunc

command! ZettelTagSearch call s:fzfzetteltags()
nnoremap <leader>zt :ZettelTagSearch<cr>

" Search tags then search and open notes containing those tags
