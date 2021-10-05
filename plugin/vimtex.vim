" Vimtex configuration
let g:vimtex_view_method='zathura'
let g:vimtex_fold_enabled=1
let g:tex_flavor='latex'

" let g:vimtex_compiler_progname='$HOME/.local/bin/nvr'
" let g:vimtex_quickfix_ignore_filters = ['Overfull \\hbox', 'Underful \\hbox']
" this disables some helful warnings that often have a reason why I ignore them
let g:vimtex_quickfix_ignore_filters = [
  \'Underfull \\hbox (badness [0-9]*) in paragraph at lines',
  \'Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in paragraph at lines',
  \'Underfull \\hbox (badness [0-9]*) in ',
  \'Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in ',
  \'Unused global option(s)',
  \]
