set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" from https://jdhao.github.io/2018/09/20/disable_warning_neomake_pylint/
" Call neomake and automake when writing or reading buffer and on changes in normal mode after 500 ms
call neomake#configure#automake('nrw',500)
"
" \ '-d', 'C0103, C0111','C0411','C0114','E402',
let g:neomake_python_pylint_maker = {
  \ 'args': [
  \ '-f', 'text',
  \ '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg}"',
  \ '-r', 'n'
  \ ],
  \ 'errorformat':
  \ '%A%f:%l:%c:%t: %m,' .
  \ '%A%f:%l: %m,' .
  \ '%A%f:(%l): %m,' .
  \ '%-Z%p^%.%#,' .
  \ '%-G%.%#',
  \ }

" TODO: This breaks extra spacing requirements
" let g:neomake_python_flake8_maker = {
"   \ 'args': [
"   \ '-d', 'E402',
"   \ '-f', 'text',
"   \ '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg}"',
"   \ '-r', 'n'
"   \ ],
"   \ 'errorformat':
"   \ '%A%f:%l:%c:%t: %m,' .
"   \ '%A%f:%l: %m,' .
"   \ '%A%f:(%l): %m,' .
"   \ '%-Z%p^%.%#,' .
"   \ '%-G%.%#',
"   \ }

let g:neomake_python_enabled_makers = ['flake8', 'pylint']
