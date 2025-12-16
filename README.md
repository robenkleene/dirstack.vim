# `dirstack`

A directory stack for Vim like in [Bash](https://www.gnu.org/software/bash/manual/html_node/The-Directory-Stack.html) or [Zsh](https://zsh.sourceforge.io/Intro/intro_6.html)

## Global

- `:Popd`: Remote the top directory in the global stack and `:cd` to it.
- `:Dirstack`: Echo the global directory stack.

## Local

- `:Lpopd`: Remote the top directory in the local stack and `:lcd` to it.
- `:Ldirstack`: Echo the local directory stack.

## Tab

- `:Lpopd`: Remote the top directory in the tab stack and `:tcd` to it.
- `:Tdirstack`: Echo the tab directory stack.

The plugin tracks working directory changes automatically (so there's no `:Pushd` command) during the `DirChangedPre` event.
