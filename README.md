# `dirstack`

A directory stack for Vim like in [Bash](https://www.gnu.org/software/bash/manual/html_node/The-Directory-Stack.html) or [Zsh](https://zsh.sourceforge.io/Intro/intro_6.html)

## `:cd`

- `:Popd`: Pop and `:cd`
- `:Dirstack`: Echo global stack

## `:lcd`

- `:Lpopd`: Pop and `:lcd`
- `:Ldirstack`: Echo local stack

## `:tcd`

- `:Tpopd`: Pop and `:tcd`
- `:Tdirstack`: Echo local stack

The plugin tracks working directory changes automatically (so there's no `:Pushd` command) during the `DirChangedPre` event.
