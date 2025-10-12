let g:dir_stack = []

command! -nargs=? Pushd call add(g:dir_stack, getcwd()) | if !empty(<q-args>) | exe 'cd' <q-args> | endif
command! Popd if !empty(g:dir_stack) | exe 'cd' remove(g:dir_stack, -1) | endif
command! Dirstack echo g:dir_stack
command! -nargs=? -complete=dir Lpushd call s:Lpushd(<q-args>)
command! Lpopd call s:Lpopd()
command! Ldirstack call s:Ldirstack()

augroup DirStack
  autocmd!
  autocmd DirChanged * call s:PushDir(v:event)
  autocmd DirChanged window call s:BufPushDir(v:event)
augroup END

augroup LocalDirStackInit
  autocmd!
  autocmd BufReadPost,BufNewFile * if !exists('b:dir_stack') | let b:dir_stack = [] | endif
augroup END
