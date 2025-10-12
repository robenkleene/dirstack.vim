command! -nargs=1 -complete=dir Pushd call dirstack:pushd(dir, 1)
command! -nargs=1 -complete=dir Lpushd call dirstack:lpushd(dir, 1)

command! Dirstack echo g:dir_stack
command! Ldirstack echo b:dir_stack

command! Lpopd call dirstack:lpopd()
command! Popd call dirstack:popd()

augroup DirStack
  autocmd!
  autocmd DirChanged * call s:DirChangedEvent(v:event)
augroup END

let g:dir_stack = []
augroup LocalDirStack
  autocmd!
  autocmd BufReadPost,BufNewFile * if !exists('b:dir_stack') | let b:dir_stack = [] | endif
augroup END
