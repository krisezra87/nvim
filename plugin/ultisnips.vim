" To get Python going, run :py3 print("whatever"), check which python version.
" For Gvim, also try :echo has("win32") to verify 32 bit.  Install matching
" python.  Then running :echo has("python3") should return 1.

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"

" Let UltiSnipsEdit split the window vertically
let g:UltiSnipsEditSplit="vertical"
