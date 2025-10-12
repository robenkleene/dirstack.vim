function! s:PushDir(event)
  " v:event has keys: scope, cwd, old_cwd
  if has_key(a:event, 'old_cwd') && a:event.old_cwd !=# ''
    call add(g:dir_stack, a:event.old_cwd)
  endif

  if len(g:dir_stack) > 50
    call remove(g:dir_stack, 0)
  endif
endfunction

function! s:BufPushDir(ev) abort
  if get(a:ev, 'scope', '') !=# 'window'
    return
  endif

  let old = get(a:ev, 'old_cwd', '')
  if empty(old)
    return
  endif

  if !empty(b:dir_stack) && b:dir_stack[-1] ==# old
    return
  endif
  call add(b:dir_stack, old)

  if len(b:dir_stack) > 50
    call remove(b:dir_stack, 0)
  endif
endfunction

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

function! s:Ldirstack() abort
  if !exists('b:dir_stack') || empty(b:dir_stack)
    echo "[]"
  else
    echo b:dir_stack
  endif
endfunction

function! s:Lpopd() abort
  if !exists('b:dir_stack') || empty(b:dir_stack)
    echohl WarningMsg | echo "Local dir stack is empty for this buffer" | echohl None
    return
  endif
  let target = remove(b:dir_stack, -1)
  execute 'lcd' fnameescape(target)
endfunction
