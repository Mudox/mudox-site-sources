+++
date = "2014-09-29T15:57:37+08:00"
draft = true
title = "VIM CHAMELEON STARTUP MENU"

tags      = ["Tool", "Vim"]
platforms = ["MacOS", "Win", "Linux"]
languages = ["Bash"]
+++

Records here the steps of making a small and neat vim-chameleon startup screen.
<!--more-->

# On Windows:

1. create a shortcut from gVim.exe.

2. right click on the shorcut to open it's property dialog.

3. append the following lines (_concatenated into one line_) to the __target__ field.

```bash
--cmd "let g:mdx_chameleon_cur_mode = 'startup'"
--cmd "set lines=9 columns=32"
--cmd "winpos 475 320"
-c "let &titlestring='Happy Vimming!'"
-c "ChamStartup"
```

4. optionally, put this shortcut under paths listed in system's $PATH environment variable.

# On Mac OSX:

the `MacVim.app` does not accepts arguemnts above, we should use:

```bash
/Applications/MacVim.app/Contents/MacOS/Vim -g
```

instead:

```bash
/Applications/MacVim.app/Contents/MacOS/Vim -g            \
        --cmd "let g:mdx_chameleon_cur_mode = 'startup'"  \
        --cmd "set lines=9 columns=22"                    \
        --cmd "winpos 880 370"                            \
        -c "let &titlestring='Happy Vimming!'"            \
        -c "let &guifont = 'Monaco for Powerline:h16'"    \
        -c "ChamStartup"
```
# On Linux:
```bash

```
