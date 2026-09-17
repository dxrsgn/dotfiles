set expandtab ts=4 sw=4 autoindent ruler number
filetype plugin indent on
set showcmd

" Russian layout: normal-mode commands work without switching layouts
" (insert mode is unaffected). Only Cyrillic keys are remapped.
let &langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЖЭХЪБЮЁ;ABCDEFGHIJKLMNOPQRSTUVWXYZ:"{}<>~,фисвуапршолдьтщзйкыегмцчняжэхъбюё;abcdefghijklmnopqrstuvwxyz\;''[]\,.`'
set nolangremap

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

" WSL: paste from the Windows clipboard with \p / \P (visual: \p replaces).
" Plain p/P still use vim's own registers.
if executable('powershell.exe')
  function! s:WslPaste(cmd) abort
    let text = system('powershell.exe -NoProfile -NonInteractive -Command '
          \ . '"[Console]::OutputEncoding=[Text.Encoding]::UTF8; Get-Clipboard -Raw"')
    " Drop CRs and the newline PowerShell appends to its output
    let text = substitute(substitute(text, '\r', '', 'g'), '\n$', '', '')
    if text ==# ''
      return
    endif
    let linewise = text =~# '\n$'
    let lines = split(linewise ? text[:-2] : text, '\n', 1)
    let saved = [getreg('"', 1, 1), getregtype('"'), getreg('0', 1, 1), getregtype('0')]
    call setreg('"', lines, linewise ? 'l' : 'c')
    execute 'normal! ' . a:cmd
    call setreg('0', saved[2], saved[3])
    call setreg('"', saved[0], saved[1])
  endfunction

  nnoremap <silent> <leader>p :<C-u>call <SID>WslPaste('p')<CR>
  nnoremap <silent> <leader>P :<C-u>call <SID>WslPaste('P')<CR>
  xnoremap <silent> <leader>p :<C-u>call <SID>WslPaste('gvp')<CR>
  " langmap doesn't apply inside mappings, so add the Russian-layout keys too
  nmap <leader>з <leader>p
  nmap <leader>З <leader>P
  xmap <leader>з <leader>p
endif
