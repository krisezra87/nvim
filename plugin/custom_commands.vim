command! SplitLines normal V<cr>:s/\([^\.]\{-}\.\)\zs\s\+\ze\u/\r/g<cr>
