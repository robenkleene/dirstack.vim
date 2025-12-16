*dirstack.txt*      A directory stack for Vim

Author:  Roben Kleene
License: Same terms as Vim itself (see |license|)

INTRODUCTION                                        *dirstack*

A directory stack for Vim. Dirstack automatically keeps a history of every
directory visited in Vim (e.g., by `:cd` or `:lcd` [the change is tracked
during the `DirChangedPre` event]).

                                                    *dirstack-:Popd*
:Popd

Remove the top directory in the stack and `:cd` to it.

                                                    *dirstack-:Dirstack*
:Dirstack

Echo the contents of the directory stack.

                                                    *dirstack-:Lpopd*
:Lpopd

Like |:Popd| but use the local directory stack.

                                                    *dirstack-:Ldirstack*
:Ldirstack

Like |:Dirstack| but use the local directory stack.

                                                    *dirstack-:Tpopd*
:Tpopd

Like |:Popd| but use the tab directory stack.

                                                    *dirstack-:Tdirstack*
:Tdirstack

Like |:Dirstack| but use the tab directory stack.


ABOUT                                               *dirstack-about*

https://github.com/robenkleene/dirstack

 vim:tw=78:et:ft=help:norl:
