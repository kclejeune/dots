set tabstop=4 shiftwidth=4 expandtab
" Auto Strip Trailing Spaces
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
" Apply to only certain files by default
" autocmd FileType c,cpp,java,php,ruby,python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
" Apply to all files by default
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
