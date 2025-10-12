function! s:PushDirEvent(event) abort
  let l:old = get(a:event, 'old_cwd', '')
  let l:local = get(a:event, 'scope', '') !== 'window')
  if l:local
    call <SID>LstackAdd(old)
  else
    call <SID>StackAdd(old)
  endif
endfunction

function! s:StackAdd(dir) abort
  if empty(dir)
    return
  endif
  " Don't add dups
  if !empty(g:dir_stack) && g:dir_stack[-1] ==# dir
    return
  endif
  call add(g:dir_stack, dir)
  if len(g:dir_stack) > 50
    call remove(g:dir_stack, 0)
  endif
endfunction

function! s:LstackAdd(dir) abort
  if empty(dir)
    return
  endif
  " Don't add dups
  if !empty(b:dir_stack) && b:dir_stack[-1] ==# dir
    return
  endif
  call add(b:dir_stack, dir)
  if len(b:dir_stack) > 50
    call remove(b:dir_stack, 0)
  endif
endfunction

function! s:Lpushd(dir) abort
  if !exists('b:dir_stack')
    let b:dir_stack = []
  endif
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
