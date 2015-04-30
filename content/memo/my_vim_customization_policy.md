+++
date = "2014-10-30T10:15:08+08:00"
draft = true
title = "MY VIM CUSTOMIZATION POLICY"

tags      = ["Tool", "Vim"]
platforms = ["MacOS", "Win", "Linux"]
languages = ["Bash"]
+++

It is the Vim that bring we into the fantastic OSS world. Fiddling with it is
full of surprise and happy.

Below records my thoughts and rules of customizing my Vim.
<!--more-->

# About Mapping

## Good prefixes for normal mode mappings

### The comma `,`

use 2 ~ 3 suffix characters, then we can get more candidates key combinations
for mapping.

### The backslash `\`

different keyboard layouts have different locations for `\`, so it should be
used less frequently than `,`.

### The space key `<Space>`

the `<Space>` is the best prefix for normal mappings I've ever found. It spans
a long distance at the bottom of the keyboard, which makes it's very easy and
comfortable to touch.

currrently, I only assigned it to

* [kien's 'CtrlP'][ctrlp] family mappings

* [my 'vim-omnimenu'][omnimenu] mappings

* [my 'vim-chameleon'][chameleon] mappings

### The enter `<Cr>` or `<Enter>`

since many vim itself and many plugin use <Cr>, so I should use it sparely.
when a single click of <Cr> is needed, you will feel a noticeable response lag.

### The backspace key `<BS>`

by default, the `<BS>` acts the same as `h`, `Ctrl-H` and `<Left>` keys on
normal mode. so I have substituted it with the `<Enter>` key as a main prefix.

### other possible key for prefixes

* `<C-P>`

* `<C-N>`

* `=`

## Mapping toggling commands

1. use `co` prefix, which is derived from [tpope's 'unimpaired'][unimparied] plugin.

2. use `,*<Space>` pattern, which is derived from [scrooloose's 'NERD commenter'][nerdcommenter] plugin.

[unimparied]:    https://github.com/tpope/vim-unimpaired.git
[nerdcommenter]: https://github.com/scrooloose/nerdcommenter.git
[ctrlp]:         https://github.com/kien/ctrlp.vim.git
[chameleon]:     https://github.com/Mudox/vim-chameleon
[omnimenu]:      https://github.com/Mudox/vim-omnimenu
