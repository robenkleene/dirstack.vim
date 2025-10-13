command! Dirstack echo get(g:, 'dir_stack', [])
command! Ldirstack echo get(b:, 'dir_stack', [])

command! Lpopd call dirstack#lpopd()
command! Popd call dirstack#popd()

augroup DirStack
  autocmd!
  autocmd DirChangedPre global call dirstack#pushd(getcwd(), v:event.directory)
  autocmd DirChangedPre window call dirstack#lpushd(getcwd(), v:event.directory)
augroup END
