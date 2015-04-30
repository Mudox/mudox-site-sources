+++
date = "2014-11-08T22:33:51+08:00"
draft = true
title = "SETUP MY ARCH LINUX ENVIRONMENT"

tags      = ["System", "Setup", "Awesome"]
platforms = ["Arch", "Linux"]
languages = ["Bash", "Lua"]
series    = ["Setup"]
+++

The marathon of installing & tunning the Arch Linux to my flavor.
<!--more-->

# SUMMARY

[Arch Linux][archlinux] + [Awesome WM][awesome] + [xterm][xterm], that is the
main skeleton of my system.

I settled on this combination under the rule:

* minimalistic environment, no huge DEs like GNOME, KDE or the likes.

* fast revolution, always surfing in the front, since it is for personal use,
  why not ...

I choose [LightDM][lightdm], because it

1. is developed __independent__ of other DEs, hence I don't have to be forced to
   install a bunch of GNOME or KDE dependency packages to only for making it
   run.

2. is __lightweight__. Very small package size, therefore starts up pretty fast, as
   I can see.

3. has many front ends (a.k.a. _greeters_) due to it cross-desktop feature.

Among various [greeters][greeters], I currently use `lightdm-gtk3-greeter`. It
has a simplistic and neat login screen, just the necessary elements I need.

# THE WINDOW MANAGER -- AWESOME WM

I have tried two ways of starting Awesome WM during system boot.

The first way, is using a _display manager_, which will presents you a login
screen, where you enter your user ID & password. After authentication, it
will start the Awesome WM for you.

The second way is to use `xinit` (and it's front-end script `startx`). When
display manager is absent in the startup process, system will bring you to one
of the tty consoles, which is just a simplistic command line interface, then
you type `startx` manually, which then, according the configuration in
`~/.xinitrc`, do some initial setting work and finally start the Awesome WM and
transfer control to it.

Of the 2 ways I've tried, I prefer the first one -- using a display
manager. Because the display manager:

* the installation & configuration process is relatively simpler than the
  _xinit_ way.

* startup dependent services (e.g. audio, network etc.) in correct order
  thanks to `systemd`'s dependency management.

* fully utilize the `systemd`'s concurrency startup feature, making the whole
  startup process pretty faster than the _xinit_ way.

* run fast, there is no need to login to tty console, and type ..., which as
  I've seen, took more time to initiates.

## With display manager

### Installing LightDM

First, install `LightDM` & `lightdm-gtk3-greeter` from official repository. An
extra advantage of choosing `lightdm-gtk3-greeter` is that you do not need to
modify the `/etc/lightdm/lightdm.conf` to let the `LightDM` back-end use it. It
is the reference (default) greeter.

Then register `LightDM` to `systemd`, making it get started on boot
automatically.

```bash
sudo pacman -S lightdm, lightdm-gtk3-greeter

sudo systemctl enable lightdm.service
```

### Configuring LightDM

## Without display manager

Without display manager, you should first login into the `tty1`, then type
`startx` to start the _Awesome WM_.

Through some configuration, the 2 steps mentioned above can be automated:

### Step 1 -- automatic login to virtual console

create the following file and its' parent directory if not exists.

```conf
# /etc/systemd/system/getty@tty1.service.d/autologin
------------------------------------------------------------------------------
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin mudox --noclear %I 38400 linux
Type=idle
```

### Step 2 -- start X at login

First install the `xorg-xinit` package from the Arch Linux official
repository, which provides the `xinit` command & its' front end -- the `startx`
script, besides, it also put a template _xinitrc_ file under `/etc/skel/`
directory.

Then, base on `/etc/skel/.xinitrc`, create `~/.xinitrc` as follows:

```bash
#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xrdb -merge ~/.Xresources # if you have ever created it.

# exec gnome-session
# exec startkde
# exec startxfce4

exec awesome # make sure it's on the last line
```

Finally, add the following code into you shell login script, such as _.profile_
for bash and _.zlogin_ for zsh.

```bash
# ~/.zlogin
------------------------------------------------------------------------------
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
```

references:

* [Automatic login to virtual console from
  ArchWiki](https://wiki.archlinux.org/index.php/Automatic_login_to_virtual_console)

* [Start X at login from ArchWiki](https://wiki.archlinux.org/index.php/Start_X_at_login)

* [xinitrc form ArchWiki](https://wiki.archlinux.org/index.php/Xinitrc)

# MOUSE ACCELERATION

Type `xset q | grep Pointer` to see current mouse acceleration setting.

Try `xset m <acceleration> <threshold>` with different values to find the best
combination for your feeling.

> where acceleration defines how many times faster the cursor will move than
> the default speed. threshold is the velocity required for acceleration to
> become effective, usually measured in device units per 10ms. acceleration can
> be a fraction, so if you want to slow down the mouse you can use 1/2, 1/3,
> 1/4, ... if you want to make it faster you can use 2/1, 3/1, 4/1, ...

> Threshold defines the point at which acceleration should occur in pixels per
> 10 ms.

I found my lucky combiantion is `1/4 8` and I add the setting command into
_rc.lua_ of [Awesome WM][awesome] to apply the setting on each startup.

references:

* [Mouse acceleration from ArchWiki](https://wiki.archlinux.org/index.php/Mouse_acceleration)

# INPUT METHOD

The **ibus + isbus-rime** combinations works nicely on my Arch Linux.

After ibus gets installed, run `ibus-setup`, it will show a setting guide
window where you can adjust ibus settings to adapt to [Awesome WM](awesome)
environment.

* I prefer to change the keyboard shortcut of switching to next input method to
  `<Atl><Shift>space`

* Check off the *Embed preedit text in application window* option, because I
  found it does not run properly in some applications (e.g. Vim).

On  environments, ibus-daemon can not be loaded automatically on
startup, so we need to manually run it. There are many ways to auto-start
applications on linux platform, I choose to let [Awesome WM](awesome) to start it by adding
auto-start code in *rc.lua*.

For ibus-rime, it is in tranditional chinese mode by default. To switch to
simplified chinese mode, press `Ctrl-~` when ibus-rime is active to open setup
candiate menu and choose *朙月拼音-简化字*

```bash
sudo pacman -S ibus ibus-qt ibus-rime

ibus-setup

# manually start ibus daemon for this session.
# this command has been added in my Awesome config file 'rc.lua' to auto-start
# it in the beginning of each Awesome session.
ibus-daemon -drx
```

references:

* [IBus from ArchWiki](https://wiki.archlinux.org/index.php/Ibus)

# WINDOW MANAGER

On Linux platforms, I prefer WMs to DEs.

The [Awesome WM][awesome] is my favorite window manager.

see [SETUP MY AWESOME WM ENVIRONMENT](/memo/setup_my_aweseome_wm_environment/)
for details.


# SHELL ENVIRONMENT

I have used several terminal emulators (gnome-terminal, xvrt ...), and finally
I settled myself on **xterm**, which I feel it:

* consume the smallest resource among other terminal emulators.

* starts up very fast.

* is much more robust.

* is the standard shell for the X Window System, which bring a great
  compatiblity.

As to shells, I become a **zsh** fan soon after played with it as well as
bash & fish shells. the reason is obvious:

* it is powerfull than bash, whose syntax is completely covered by zsh.

* it provides more flexibility in configuration than fish shell.

* there already exist quite a many user contributed resources on the net, e.g:

  + [on-my-zsh](https://github.com/robbyrussell/oh-my-zsh).

  + [antigen](https://github.com/zsh-users/antigen) plugin manager.

## Pull down dot-files repo

My configuration resource related to termianl emulator & shells are managed in
a github repo -- [dot-files][dotfile].

```bash
cd ~/Git # ~/Git is the place I assemble most of my github repos.
git clone https://github.com/Mudox/dot-files.git
```

## Setup xterm

First, install xterm from Arch Linux's official repository.

Then, link out the .Xresources file from my [dot-files][dotfile] repo. It is
the configuration file that hold my xterm settings (colors, cursors, fonts
etc.) among other x utility setttings.

```bash
sudo pacman -S xterm
cd ~
ln -sf Git/dot-files/Xresources .Xresources
```

## Setup zsh

see [SETUP MY ZSH ENVIRONMENTS](/memo/setup_my_zsh_environment/) for details.

# SETUP VIRTUALBOX

## Installing Virtualbox

First, from the official repository, install `virtualbox` package, which comes
with `virtualbox-host-modules`.

Then we need to add the basic **vboxdrv** kernel module to host kernel.

Finally, add my user name to the **vboxusers** group in order to use USB port in
virtual machines.

```bash
sudo pacman -S virtualbox

# manually add vboxdrv to host kernel for one time.
sudo modeprobe vboxdrv

# auto-load vboxdrv on every system startup.
sudo echo 'vboxdrv' > /etc/modules-load.d/virtualbox.conf

# add user name in vboxusers group to use USB ports in vitual machines.
sudo gpasswd -a "${USER}" vboxusers
```

## Configuring Virtualbox

1. Set *Host Key Combination* to `right <winkey>` which is consistent with
   [Awesome WM](awesome)'s keyboads shortcuts, it's in
   *File->Preference->Input->Virtual Machine* of *Oracle VM VitualBox Manager*
   window.

2. Enalbe *Bidiretional clipboard*, it's in *Devices->Shared
   Clipboard->Bidirectional* of virtual machine window.

references:

* [Virtualbox from ArchWiki](https://wiki.archlinux.org/index.php/Virtualbox)

* [kernel\_modules from ArchWiki](https://wiki.archlinux.org/index.php/Kernel_modules)


# VPN

## Setup pptpclient

1. install pptpclient from the official repository of Arch Linux.

2. use `pptpsetup` command to register my VPN account, which is just a helper
   script that will create a readable text file `/etc/ppp/peers/<tunnel_name>`
   where you can change the server address manaually using whatever text editor
   you like. collect the following information in advance:

   + VPN server's __ip address__ from your VPN provider.

   + __user name__ of your VPN account.

   + __user password__ of your VPN account.


3. install `ppp-mppe` (i.e. Microsoft Pointer-to-Pointer Encryption), if the
   `pptpsetup` command complains about *MPPE* module things.

4. test configuration

   + use `pon <tunnel_name> debug dump logfd 2 nodetach` to test the
     configuration. If everything has been configured correctly, the command
     should not terminate. `Ctrl-C` to quit it.

   + type `ip addr show`, and you will see a new device **ppp0** is listed in.

5. connect VPN using `sudo pon <tunnel_name>`, `sudo poff <tunnel_name>` to
   tear down.

```bash
# install pptpclient
sudo pacman -S pptpclient

# add you VPN account (i.e. create a new tunnel)
sudo pptpsetup \
  --create <tunnel_name_whatever_you_like> \
  --server <your_VPN_server_ip_address> \
  --username <username_of_you_VPN_account> \
  --password <password_of_you_VPN_account> \
  --encrypt

# install ppp-mppe, if the command above complains about lacking of `MPPE`
# module things. rerun `pptpsetup` command above after installing it.
sudo pacman -S ppp-mppe

# test 1, the command should not terminate if everything is okay.
sudo pon <tunnel_name_above> debug dump logfd 2 nodetach

# test 2, you would see `ppp0` listed in the output.
ip addr show

# finally, connect!
sudo pon <tunnel_name>
```
## Route all traffic through VPN connection

### Manually

Use the powerfull `ip` command to add a route rule into route table.

```bash
# make all packages go through interface ppp0
ip route add default dev ppp0
```

This route rule is only effective during this ppp session. after your tear down
the VPN connection by `sudo pon <tunnel_name>`, it will vanish.

### Automatically

Every executable scripts under /etc/ppp/ip-up.d/ will be called when a VPN
connection startup. Hence, we can use it to automatically set route rules.

```bash
# /etc/ppp/ip-up.d/01-routes.sh
# ----------------------------------------
#!/bin/bash

# This script is called with the following arguments:
# Arg Name
# $1 Interface name
# $2 The tty
# $3 The link speed
# $4 Local IP number
# $5 Peer IP number
# $6 Optional ``ipparam'' value foo

ip route add default via $4
```

```bash
cd /etc/ppp/ip-up.d
echo 'ip route add default via $4' > 01-routes.sh

# the script file need to have `x` permission to be run.
# it's stdin & stderr will be redirected off terminal, so not output will
# be shown when run.
co
sudo chmod +x /etc/ppp/ip-up.d/01-routes.sh
```

## Modify DNS server list

If you found you still can not access some site (e.g. youtube, twitter, etc.)
after establishing the VPN connection, then you should insert `servername
8.8.8.8` ahead of existing lines in _/etc/resolve.conf_.

```bash
# /etc/resolve.conf
# ----------------------------------------
nameserver 8.8.8.8
nameserver 192.168.0.1
```

### My hacky way

I wrote a script to get around of this:

```bash
# ~/.bin/vpn.sh
# ----------------------------------------
#!/bin/sh

tunnel="your configured tunnel name"

if [ "$#" -ne 1 ]; then
  echo "usage: $0 [on|off]"
  exit 1
fi

case "$1" in
  on )
    # connect
    pon ${tunnel} || exit 1

    # here we just overwrite the /etc/resolv.conf by `echo`ing the hard
    # written DNS list to it.
    printf "nameserver 8.8.8.8\nnameserver 192.168.0.1" > /etc/resolv.conf || exit 1
    ;;
  off )
    # disconnect
    poff ${tunnel}

    # some as above, we just `echo` back.
    echo 'nameserver 192.168.0.1' > /etc/resolv.conf || exit 1
    ;;
  * )
    echo "usage: $0 [on|off]"
    ;;
esac

unset tunnel
```

in your .bashrc or .zshrc file:

```bash
alias vpon='sudo ~/.bin/vpn.sh on'
alias vpoff='sudo ~/.bin/vpn.sh off'
```

then, you can type `vpon` to turn on the VPN, and `vpoff` to shutdown.

references:

* [PPTP VPN client setup with pptpclient][pptp]

[pptp]: https://wiki.archlinux.org/index.php/PPTP_VPN_client_setup_with_pptpclient
[lightdm]: http://www.freedesktop.org/wiki/Software/LightDM/
[greeters]: https://wiki.archlinux.org/index.php/lightdm#Greeter
[xterm]: http://invisible-island.net/xterm/
[archlinux]: https://wiki.archlinux.org
[dotfile]: https://github.com/Mudox/dot-files.git
[awesome]: http://awesome.naquadah.org
