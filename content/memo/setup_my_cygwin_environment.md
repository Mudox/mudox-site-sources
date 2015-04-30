+++
date  = "2014-11-05T09:26:59+08:00"
draft = true
title = "SETUP MY CYGWIN ENVIRONMENT"

tags      = ["Tool", "Shell", "Bash", "Zsh", "Setup"]
platforms = ["Win"]
languages = ["Bash"]
series    = ["Setup"]
+++

Cygwin -- bring \*nix command line user experence (paritially though) and
efficiency onto Windows.
Below is the steps of setting up the Cygwin environment on my Windows.
<!--more-->

# Why Cygwin over other tools.

# Setup Cygwin

## Cygwin path remapping

## mintty setting

## color

### mintty color palette

### ls\_color

### colorful manpage

### colout

## encoding

## other settings

## Shell environment setup

## Cygwin package manager

# Cygwin Using Tips

## Working with gVim of Windows

Most of the time, I prefer gui version of Vim than terminal version for it
being free of various shackles of terminal emulator, such as key confliction,
color presentation limit, UI rendering efficiency limit, etc.

First make sure a gVim instance already exists outside of Cygwin.

When I need to handle off some files to gVim for Windows, I can use `--remote`
(type `:h clientserver` in gVim for details) command families, for example:


```bash
alias gvim='/c/Program Files/Vim/vim74/gvim.exe'

gvim --remote-tab /path/of/file
```

it will open the file in new tab of an already running gVim instance.
