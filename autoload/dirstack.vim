function! dirstack#pushd(dir) abort
  if empty(a:dir)
    return
  endif
  if !exists('g:dir_stack') || type(g:dir_stack) != type([])
    let g:dir_stack = []
  endif

  let l:dir = simplify(fnamemodify(a:dir, ':p'))
  let l:top = empty(g:dir_stack) ? "" : g:dir_stack[-1]

  call add(g:dir_stack, l:dir)

  if len(g:dir_stack) > 20
    call remove(g:dir_stack, 0)
  endif
endfunction

function! dirstack#lpushd(dir) abort
  if empty(a:dir)
    return
  endif
  if !exists('b:dir_stack') || type(b:dir_stack) != type([])
    let b:dir_stack = []
  endif

  let l:dir = simplify(fnamemodify(a:dir, ':p'))
  let l:top = empty(b:dir_stack) ? "" : b:dir_stack[-1]

  call add(b:dir_stack, l:dir)

  if len(b:dir_stack) > 20
    call remove(b:dir_stack, 0)
  endif
endfunction

function! dirstack#tpushd(dir) abort
  if empty(a:dir)
    return
  endif
  if !exists('t:dir_stack') || type(t:dir_stack) != type([])
    let t:dir_stack = []
  endif

  let l:dir = simplify(fnamemodify(a:dir, ':p'))
  let l:top = empty(t:dir_stack) ? "" : t:dir_stack[-1]

  call add(t:dir_stack, l:dir)

  if len(t:dir_stack) > 20
    call remove(t:dir_stack, 0)
  endif
endfunction

function! dirstack#popd() abort
  if !exists('g:dir_stack')
    echohl WarningMsg | echo "Dir stack is empty" | echohl None
    return
  endif

  while !empty(g:dir_stack) && !isdirectory(g:dir_stack[-1])
    call remove(g:dir_stack, -1)
  endwhile

  if empty(g:dir_stack)
    echohl WarningMsg | echo "Dir stack is empty" | echohl None
    return
  endif

  let l:dir = remove(g:dir_stack, -1)
  let l:cwd = simplify(fnamemodify(getcwd(), ':p'))
  execute 'cd ' . fnameescape(l:dir)
  " The cd will add this dir to the stack so remove it to prevent the pop from
  " re-adding to the stack
  if l:cwd == g:dir_stack[-1]
    call remove(g:dir_stack, -1)
  endif
endfunction

function! dirstack#lpopd() abort
  if !exists('b:dir_stack')
    echohl WarningMsg | echo "Local dir stack is empty for this buffer" | echohl None
    return
  endif

  while !empty(b:dir_stack) && !isdirectory(b:dir_stack[-1])
    call remove(b:dir_stack, -1)
  endwhile

  if empty(b:dir_stack)
    echohl WarningMsg | echo "Local dir stack is empty for this buffer" | echohl None
    return
  endif

  let l:dir = remove(b:dir_stack, -1)
  let l:cwd = simplify(fnamemodify(getcwd(), ':p'))
  execute 'lcd ' . fnameescape(l:dir)
  " The cd will add this dir to the stack so remove it to prevent the pop from
  " re-adding to the stack
  if l:cwd == b:dir_stack[-1]
    call remove(b:dir_stack, -1)
  endif
endfunction

function! dirstack#tpopd() abort
  if !exists('t:dir_stack')
    echohl WarningMsg | echo "Local dir stack is empty for this tab page" | echohl None
    return
  endif

  while !empty(t:dir_stack) && !isdirectory(t:dir_stack[-1])
    call remove(t:dir_stack, -1)
  endwhile

  if empty(t:dir_stack)
    echohl WarningMsg | echo "Local dir stack is empty for this tab page" | echohl None
    return
  endif

  let l:dir = remove(t:dir_stack, -1)
  let l:cwd = simplify(fnamemodify(getcwd(), ':p'))
  execute 'tcd ' . fnameescape(l:dir)
  " The cd will add this dir to the stack so remove it to prevent the pop from
  " re-adding to the stack
  if l:cwd == t:dir_stack[-1]
    call remove(t:dir_stack, -1)
  endif
endfunction
