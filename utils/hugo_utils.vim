" vim: foldmethod=marker

" GUARD {{{1
"if exists("s:loaded") || &cp || version < 700
  "finish
"endif
"let s:loaded = 1
" }}}1

function! UpdateDate() " {{{2
  let time_string = strftime("%Y-%m-%dT%d:%M:%S+08:00")
  let line = printf("date = \"%s\"", time_string)
  echo line
  call setline(2, line)
endfunction "  }}}2
