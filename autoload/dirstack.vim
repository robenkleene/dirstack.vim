function! dirstack#pushd(dir, new = "") abort
  if empty(a:dir)
    return
  endif
  if !exists('g:dir_stack') || type(g:dir_stack) != type([])
    let g:dir_stack = []
  endif

  let l:dir = simplify(fnamemodify(a:dir, ':p'))
  let l:top = empty(g:dir_stack) ? "" : g:dir_stack[-1]
  " Don't add dups
  if l:top ==# l:dir
    return
  endif

  if !empty(a:new)
    let simplify(fnamemodify(a:new, ':p'))
    " If going back to top directory pop and do nothing
    " This treats going back to a directory as a manual pop, so `cd -` is
    " treated as a pop and a subsequent `:Popd` will then go back further in
    " history
    if l:top ==# l:new
      call remove(g:dir_stack, -1)
      return
    endif
  endif

  call add(g:dir_stack, l:dir)

  if len(g:dir_stack) > 20
    call remove(g:dir_stack, 0)
  endif
endfunction

function! dirstack#lpushd(dir, new = "") abort
  if empty(a:dir)
    return
  endif
  if !exists('b:dir_stack') || type(b:dir_stack) != type([])
    let b:dir_stack = []
  endif

  let l:dir = simplify(fnamemodify(a:dir, ':p'))
  let l:top = empty(b:dir_stack) ? "" : b:dir_stack[-1]
  " Don't add dups
  if l:top ==# l:dir
    return
  endif

  if !empty(a:new)
    let l:new = simplify(fnamemodify(a:new, ':p'))
    " If going back to top directory pop and do nothing
    " This treats going back to a directory as a manual pop, so `cd -` is
    " treated as a pop and a subsequent `:Popd` will then go back further in
    " history
    if l:top ==# l:new
      call remove(b:dir_stack, -1)
      return
    endif
  endif

  call add(b:dir_stack, l:dir)

  if len(b:dir_stack) > 20
    call remove(b:dir_stack, 0)
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

  " Don't remove on a pop, `pushd` removes, if a remove here the destination
  " will get re-added to the stack
  let dir = g:dir_stack[-1]
  execute 'cd ' . fnameescape(dir)
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

  " Don't remove on a pop, `pushd` removes, if a remove here the destination
  " will get re-added to the stack
  let dir = b:dir_stack[-1]
  execute 'lcd ' . fnameescape(dir)
endfunction
