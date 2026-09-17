set expandtab ts=4 sw=4 autoindent ruler number
filetype plugin indent on
set showcmd

" WSL: copy yanks to the Windows clipboard.
" clip.exe mangles UTF-8, so convert to UTF-16LE first.
if executable('clip.exe')
  function! s:WslYank() abort
    if v:event.operator ==# 'y'
      call system('iconv -f utf-8 -t utf-16le | clip.exe', v:event.regcontents)
    endif
  endfunction

  augroup WslYank
    autocmd!
    autocmd TextYankPost * call s:WslYank()
  augroup END
endif
