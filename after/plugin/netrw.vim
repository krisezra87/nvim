" Set up netrw to my liking

" Proper listing style for directories
let g:netrw_liststyle = 4

" No banner
let g:netrw_banner = 0

" No alternate file for netrw, instead <C-^> goes back to last edited file
let g:netrw_altfile=1

" Tune up a little function here to make backspace behave like we want.
" : echo @#
function! BufSwitch()
    if empty(@#)
        exec "bp"
    else
        exec "normal "
    endif
endfunction

nnoremap <silent> <BS> :call BufSwitch()<CR>
