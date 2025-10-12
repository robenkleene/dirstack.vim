let g:dir_stack = []

command! -nargs=? Pushd call add(g:dir_stack, getcwd()) | if !empty(<q-args>) | exe 'cd' <q-args> | endif
command! Popd if !empty(g:dir_stack) | exe 'cd' remove(g:dir_stack, -1) | endif
command! Dirstack echo g:dir_stack

augroup DirStack
  autocmd!
  autocmd DirChanged * call s:PushDir(v:event)
  autocmd DirChanged window call s:BufPushDir(v:event)
augroup END

augroup LocalDirStackInit
  autocmd!
  autocmd BufReadPost,BufNewFile * if !exists('b:dir_stack') | let b:dir_stack = [] | endif
augroup END



" --- Commands that operate *only* on the current buffer's stack ---

" Lpushd [dir]: push current window-local cwd onto this buffer's stack,
" then :lcd into [dir] if provided.
command! -nargs=? -complete=dir Lpushd call s:Lpushd(<q-args>)
function! s:Lpushd(dir) abort
  if !exists('b:dir_stack')
    let b:dir_stack = []
  endif
  " Push current window-local CWD
  call add(b:dir_stack, getcwd())
  if !empty(a:dir)
    execute 'lcd' fnameescape(a:dir)
  endif
endfunction

" Lpopd: pop from this buffer's stack and :lcd there
command! Lpopd call s:Lpopd()
function! s:Lpopd() abort
  if !exists('b:dir_stack') || empty(b:dir_stack)
    echohl WarningMsg | echo "Local dir stack is empty for this buffer" | echohl None
    return
  endif
  let target = remove(b:dir_stack, -1)
  execute 'lcd' fnameescape(target)
endfunction

" Ldirstack: show this buffer's local dir stack
command! Ldirstack call s:Ldirstack()
function! s:Ldirstack() abort
  if !exists('b:dir_stack') || empty(b:dir_stack)
    echo "[]"
  else
    echo b:dir_stack
  endif
endfunction
