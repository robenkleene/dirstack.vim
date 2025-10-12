function! dirstack:DirChanged(event) abort
  let l:old = get(a:event, 'old_cwd', '')
  let l:local = get(a:event, 'scope', '') !== 'window')
  if l:local
    call <SID>LstackAdd(old)
  else
    call <SID>StackAdd(old)
  endif
endfunction

function! dirstack:pushd(dir, cd = 0) abort
  if empty(dir)
    return
  endif
  " Don't add dups
  if !empty(g:dir_stack) && g:dir_stack[-1] ==# dir
    return
  endif
  call add(g:dir_stack, dir)
  if len(g:dir_stack) > 20
    call remove(g:dir_stack, 0)
  endif
  if a:cd
    execute 'cd' fnameescape(dir)
  endif
endfunction

function! dirstack:lpushd(dir, cd = 0) abort
  if empty(dir)
    return
  endif
  " Don't add dups
  if !empty(b:dir_stack) && b:dir_stack[-1] ==# dir
    return
  endif
  call add(b:dir_stack, dir)
  if len(b:dir_stack) > 20
    call remove(b:dir_stack, 0)
  endif
  if a:cd
    execute 'lcd' fnameescape(dir)
  endif
endfunction

function! dirstack:popd() abort
  if empty(b:dir_stack)
    echohl WarningMsg | echo "Dir stack is empty" | echohl None
    return
  endif
  let dir = remove(g:dir_stack, -1)
  execute 'cd' fnameescape(dir)
endfunction

function! dirstack:lpopd() abort
  if empty(b:dir_stack)
    echohl WarningMsg | echo "Local dir stack is empty for this buffer" | echohl None
    return
  endif
  let dir = remove(b:dir_stack, -1)
  execute 'lcd' fnameescape(dir)
endfunction
