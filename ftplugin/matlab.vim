" Vim filetype plugin file
" Language:	matlab
" Maintainer:	Fabrice Guy <fabrice.guy at gmail dot com>
" Last Changed: 2009 Nov 23 - Automatic insertion of comment header when new
" comment inserted

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo-=C

setlocal fo+=croql
setlocal comments=:%>,:%

if exists("loaded_matchit")
  let s:conditionalEnd = '\(([^()]*\)\@!\<end\>\([^()]*)\)\@!'
  let b:match_words = '\<classdef\>\|\<methods\>\|\<events\>\|\<properties\>\|\<if\>\|\<while\>\|\<for\>\|\<switch\>\|\<try\>\|\<function\>:' . s:conditionalEnd
endif

setlocal suffixesadd=.m
setlocal suffixes+=.asv

let b:undo_ftplugin = "setlocal suffixesadd< suffixes< "
      \ . "| unlet! b:browsefilter"
      \ . "| unlet! b:match_words"

let &cpo = s:save_cpo

call neomake#configure#automake('nrw',500)
let g:neomake_matlab_mlint_maker = {
    \ 'exe': '/usr/local/MATLAB/R2021b/bin/glnxa64/mlint',
    \ 'args': ['-id'],
    \ 'mapexpr': "neomake_bufname.':'.v:val",
    \ 'errorformat':
    \   '%f:L %l (C %c): %m,'.
    \   '%f:L %l (C %c-%*[0-9]): %m,',
    \ }
"

let g:neomake_matlab_enabled_makers = ['mlint']
