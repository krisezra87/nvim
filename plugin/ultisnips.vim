" To get Python going, run :py3 print("whatever"), check which python version.
" For Gvim, also try :echo has("win32") to verify 32 bit.  Install matching
" python.  Then running :echo has("python3") should return 1.

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<leader><leader>"
let g:UltiSnipsJumpForwardTrigger="<leader><leader>"
let g:UltiSnipsJumpBackwardTrigger="<leader>p"

" Let UltiSnipsEdit split the window vertically
let g:UltiSnipsEditSplit="vertical"

" function! UltiSnipsLazyLoad()
"     let l:my_ft = &filetype
"     call plug#load('ultisnips')
"     let &filetype = l:my_ft
"     imap <silent> <leader><leader> <C-R>=UltiSnips#ExpandSnippetOrJump()<CR>
"     return UltiSnips#ExpandSnippetOrJump()
" endfunction

" inoremap <silent> <leader><leader> <C-r>=UltiSnipsLazyLoad()<CR>
" inoremap <silent> <leader><leader> <C-R>=UltiSnips#ExpandSnippetOrJump()<CR>
