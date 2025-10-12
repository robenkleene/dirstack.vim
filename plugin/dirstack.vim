let g:dir_stack = []

command! -nargs=? Pushd call add(g:dir_stack, getcwd()) | if !empty(<q-args>) | exe 'cd' <q-args> | endif
command! Popd if !empty(g:dir_stack) | exe 'cd' remove(g:dir_stack, -1) | endif
command! Dirstack echo g:dir_stack

" --- Directory stack setup ---
if !exists('g:dir_stack')
  let g:dir_stack = []
endif

" Push old directory before changing to a new one
augroup DirStack
  autocmd!
  autocmd DirChanged * call s:PushDir(v:event)
augroup END

function! s:PushDir(event)
  " v:event has keys: scope, cwd, old_cwd
  if has_key(a:event, 'old_cwd') && a:event.old_cwd !=# ''
    call add(g:dir_stack, a:event.old_cwd)
  endif
endfunction

" ===== Local (per-buffer) directory stack for :lcd =====

" Initialize an empty per-buffer stack when a buffer is loaded/created
augroup LocalDirStackInit
  autocmd!
  autocmd BufReadPost,BufNewFile * if !exists('b:dir_stack') | let b:dir_stack = [] | endif
augroup END

" Whenever the working directory changes *for the current window* (i.e., via :lcd),
" push the *old* cwd onto the current buffer's stack.
augroup LocalDirStack
  autocmd!
  " DirChanged event is available in Vim 8+/Neovim. v:event has old_cwd/cwd/scope.
  autocmd DirChanged window call s:BufPushOldCwd(v:event)
augroup END

function! s:BufPushOldCwd(ev) abort
  " Only handle window-local changes (i.e., :lcd)
  if get(a:ev, 'scope', '') !=# 'window'
    return
  endif
  " Ensure the current buffer has a stack
  if !exists('b:dir_stack')
    let b:dir_stack = []
  endif
  let old = get(a:ev, 'old_cwd', '')
  if empty(old)
    return
  endif
  " Avoid consecutive duplicates
  if !empty(b:dir_stack) && b:dir_stack[-1] ==# old
    return
  endif
  call add(b:dir_stack, old)

  " (Optional) cap the stack size
  if len(b:dir_stack) > 50
    call remove(b:dir_stack, 0)
  endif
endfunction

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
