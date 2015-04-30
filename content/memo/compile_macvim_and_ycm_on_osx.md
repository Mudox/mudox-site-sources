+++
date      = "2014-09-29T18:00:42+08:00"
draft     = true
title     = "COMPILE MACVIM & YCM ON OSX"

tags      = ["Tool"]
platforms = ["MacOS"]
languages = ["Bash"]
+++

Compiling [Youcompleteme][ycm] and [Macvim][macvim] on MacOSX once beaten me
down for several nights.
<!--more-->

I eventually found out that this is because the interference from
[pyenv][pyenv] and [homebrew][brew].

[homebrew][brew] installs packages into a unconventional path, which makes
MacVim and Youcompleteme can found buidling dependencies in default paths.

While [pyenv][pyenv] will shadow [Macvim][macvim]'s default python ...

# Preparation

- disable pyenv

    1. run `brew unlink pyenv` (`brew link pyenv` after compilation)

    2. restart shell (e.g. itemr2)

- reset develop directory of Xcode

    1. `sudo xcode-select -r`

# Compile YCM

On MacOSX using native clang package has proven to be very stable, besides, it
drastically accelerates the installing process -- leaving `install.sh` no need
to download the prebuild binaries from LLVM's site.

```bash
cd /to/ycm/root/directory/
    ./install.sh --clang-completer --system-libclang
```

# Compile MacVim

```bash
make distclean
./configure               \
    --with-features=huge  \
    -with-macarchs=x86_64 \
    --enable-perlinterp   \
    --enable-rubyinterp   \
    --enable-pythoninterp \
    --enable-luainterp    \
    --enable-perlinterp   \
    --enable-cscope       \
    --with-lua-prefix=/usr/local/Cellar/lua/<current_version> >/tmp/log
make
```

[ycm]: http://valloric.github.io/YouCompleteMe/
[macvim]: https://github.com/b4winckler/macvim
[pyenv]: https://github.com/yyuu/pyenv
[homebrew]: http://brew.sh/
