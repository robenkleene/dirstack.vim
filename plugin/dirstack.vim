command! Dirstack echo get(g:, 'dir_stack', [])
command! Ldirstack echo get(b:, 'dir_stack', [])
command! Tdirstack echo get(t:, 'dir_stack', [])

command! Lpopd call dirstack#lpopd()
command! Tpopd call dirstack#tpopd()
command! Popd call dirstack#popd()

augroup DirStack
  autocmd!
  autocmd DirChangedPre global call dirstack#pushd(getcwd())
  autocmd DirChangedPre window call dirstack#lpushd(getcwd())
  autocmd DirChangedPre tabpage call dirstack#tpushd(getcwd())
augroup END
