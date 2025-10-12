command! Dirstack echo get(g:, 'dir_stack', [])
command! Ldirstack echo get(b:, 'dir_stack', [])

command! Lpopd call dirstack#lpopd()
command! Popd call dirstack#popd()

augroup DirStack
  autocmd!
  autocmd DirChangedPre global call dirstack#pushd(getcwd())
  autocmd DirChangedPre window call dirstack#lpushd(getcwd())
augroup END

if !exists('g:dir_stack')
  let g:dir_stack = []
endif

augroup LocalDirStack
  autocmd!
  autocmd BufReadPost,BufNewFile * if !exists('b:dir_stack') | let b:dir_stack = [] | endif
augroup END
