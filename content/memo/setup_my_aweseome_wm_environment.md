+++
date = "2014-11-05T09:28:07+08:00"
draft = true
title = "SETUP MY AWESOME WM ENVIRONMENT"

tags      = ["Tool", "Awesome", "Setup"]
platforms = ["Linux", "Arch"]
languages = ["Bash", "Lua"]
series    = ["Setup"]
+++

Awesome WM let you maniplate system windows like using Vim, besides its
bleeding fast window UI rendering & switching speed on \*nix platform I've ever
seen.

Below records my steps of setting up the Awesome window manager on my Arch
Linux progressively.
<!--more-->

# Installing Awesome Packages

The awesome package is in the official repository of Arch Linux.

Better install Xephyr for testing cases.

```bash
sudo pacman -S awesome xorg-xephyr
```

# Pulling Down My Awesome-Config Repository

The pulled down repo must be put in ~/.config/awesome, where awesome will
correctly load the configuration resources.


```bash
mkdir ~/.config # if .config does not exist before.
cd ~/.config
git clone https://github.com/Mudox/awesome-config.git awesome
cd awesome
git submodule update --init --recursive
```

[awesome]: http://awesome.naquadah.org/
