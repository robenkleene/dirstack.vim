function! dirstack#DirChanged(event) abort
  let l:old = get(a:event, 'old_cwd', '')
  let l:local = get(a:event, 'scope', '') ==# 'window'
  if l:local
    call dirstack#lpushd(l:old)
  else
    call dirstack#pushd(l:old)
  endif
endfunction

function! dirstack#pushd(dir, cd = 0) abort
  if empty(a:dir)
    return
  endif
  if !exists('g:dir_stack') || type(g:dir_stack) != type([])
    let g:dir_stack = []
  endif
  " Normalize to absolute, simplified path and don't add dups
  let l:dir = simplify(fnamemodify(a:dir, ':p'))
  if !empty(g:dir_stack) && g:dir_stack[-1] ==# l:dir
    return
  endif
  call add(g:dir_stack, l:dir)
  if len(g:dir_stack) > 20
    call remove(g:dir_stack, 0)
  endif
  if a:cd
    execute 'cd ' . fnameescape(l:dir)
  endif
endfunction

function! dirstack#lpushd(dir, cd = 0) abort
  if empty(a:dir)
    return
  endif
  if !exists('b:dir_stack') || type(b:dir_stack) != type([])
    let b:dir_stack = []
  endif
  " Normalize to absolute, simplified path and don't add dups
  let l:dir = simplify(fnamemodify(a:dir, ':p'))
  if !empty(b:dir_stack) && b:dir_stack[-1] ==# l:dir
    return
  endif
  call add(b:dir_stack, l:dir)
  if len(b:dir_stack) > 20
    call remove(b:dir_stack, 0)
  endif
  if a:cd
    execute 'lcd ' . fnameescape(l:dir)
  endif
endfunction

function! dirstack#popd() abort
  if !exists('g:dir_stack') || empty(g:dir_stack)
    echohl WarningMsg | echo "Dir stack is empty" | echohl None
    return
  endif
  let dir = remove(g:dir_stack, -1)
  execute 'cd ' . fnameescape(dir)
endfunction

function! dirstack#lpopd() abort
  if !exists('b:dir_stack') || empty(b:dir_stack)
    echohl WarningMsg | echo "Local dir stack is empty for this buffer" | echohl None
    return
  endif
  let dir = remove(b:dir_stack, -1)
  execute 'lcd ' . fnameescape(dir)
endfunction
