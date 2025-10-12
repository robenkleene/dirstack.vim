command! -nargs=1 -complete=dir Pushd call dirstack#pushd(<f-args>, 1)
command! -nargs=1 -complete=dir Lpushd call dirstack#lpushd(<f-args>, 1)

command! Dirstack echo get(g:, 'dir_stack', [])
command! Ldirstack echo get(b:, 'dir_stack', [])

command! Lpopd call dirstack#lpopd()
command! Popd call dirstack#popd()

augroup DirStack
  autocmd!
  autocmd DirChanged * call dirstack#DirChanged(v:event)
augroup END

if !exists('g:dir_stack')
  let g:dir_stack = []
endif

augroup LocalDirStack
  autocmd!
  autocmd BufReadPost,BufNewFile * if !exists('b:dir_stack') | let b:dir_stack = [] | endif
augroup END
