+++
date = "2014-11-08T17:40:55+08:00"
draft = true
title = "SETUP MY VIM ENVIRONMENT"

tags      = ["Tool", "Vim", "Setup"]
platforms = ["Linux", "Arch", "MacOS", "Win"]
languages = ["Bash", "VimL"]
series    = ["Setup"]
+++

It is the Vim that bring we into the marvelous OSS world. Fiddling with it is
full of surprise and happy.

Below records my steps of setting up my Vim environment after every system
re-installation.
<!--more-->

# Installing Vim

my vim config have be tested on:

+ Windows XP and above.

+ Mac OSX 10.9 and above using [MacVim][macvim].

+ Arch Linux.

**NOTE**: currently I prefer to GUI version than terminal version, hence most
of my configurations are tailored to GUI environments.

# Setup My Vim-Config Repo

First pull down my [vim-config][vim-config] repo from github.

Then create a directory named *neobundle* under the pulled down repo, which
will holds almost all vim plugins that will be synced by [neobundle][neobundle]
later.

Create the initial *cur_mode* file under *.vim/chameleon/*, which always stores
the chameleon mode of next vim session.

```bash
# On Widnows, Must Be Put In C:/Documents And Settings/<User Name>/Vimfiles
git clone https://github.com/Mudox/vim-config.git ~/.vim

cd .vim
mkdir neobundle

cd chameleon
echo 'all' > cur_mode
```

# Install Prerequisites Vim Plugins

## Install [vim-chameleon][chameleon]

[vim-chameleon][chameleon] is my own plugin for managing massive and ever
growing vim & vim plugin configurations.

```bash
cd ~/.vim/neobundle
# NOTE: The Renaming Is Important
git clone https://github.com/Mudox/vim-chameleon chameleon
```

## Install [neobundle][neobundle].

[neobundle][neobundle] is a sophisticated vim plugin manager that I have been
using for a long time.


```bash
cd ~/.vim/neobundle
# NOTE: The Renaming Is Important
git clone https://github.com/Shougo/neobundle.vim neobundle
```

## Install & compile [vimproc][vimproc].

[vimproc][vimproc] is another plugin written by [Shougo][shougo] that is very
useful, and is required by [neobundle][neobundle]. The point is that you need to
compile it to get a dynamic library after pulling down its' repo.

```bash
cd ~/.vim/neobundle
# NOTE: The Renaming Is Important
git clone https://github.com/Shougo/vimproc.vim vimproc

cd vimproc
make # see vimproc/README.md for compilation commands for various platforms.
```

## Run vim to see all other 140+ plugins get installed.

You can run vim in terminals or open gVim. Better run vim in terminal to watch
the plugins installing progress and spot any errors clearly.

# Vim Environment For Specific Use Case

## Web Developing

Node.js (and NPM which comes with it) is the essentials of everything below.

### HTML

### JavaScript

I use:

* [jshint](https://github.com/jshint/jshint) &
  [eshint](https://github.com/eslint/eslint) &
  [jslint](https://github.com/douglascrockford/JSLint.git) for [syntastic]
  checkers.

* [js-beautify](https://github.com/beautify-web/js-beautify) to prettify
  JavaScript code.

```bash
npm install jshint -g
npm install jslint -g
npm install eslint -g
npm install js-beautify -g
```

### CSS

I use:

* [csslint](https://github.com/CSSLint/csslint) for [syntastic] checkers.

* [csscomb.js](https://github.com/csscomb/csscomb.js) for CSS code prettifier.

```bash
npm intall csslint -g
npm install csscomb -g
```

## Python Scripting

## Lua Scripting

## Go Scripting

## C/C++ Coding


[chameleon]:  https://github.com/Mudox/vim-chameleon
[neobundle]:  https://github.com/Shougo/neobundle.vim
[vimproc]:    https://github.com/Shougo/vimproc.vim
[vim-config]: https://github.com/Mudox/vim-config
[shougo]:     https://github.com/Shougo
[macvim]:     https://github.com/b4winckler/macvim
[syntastic]:  https://github.com/scrooloose/syntastic
