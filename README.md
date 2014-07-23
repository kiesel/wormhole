# Wormhole

## About
Imagine this: you have a host OS and a virtualized guest; all development takes place on the guest; filesystems are mounted from guest to host, but when you ssh into the guest, there is no effective way of opening a modern editor, or a shell or new terminal.

Wormhole is here to fix that.

## Installation

* On the host, run

    ./install.sh host

* On the guest, run

    ./install.sh guest

This will symlink the needed files into `$HOME/bin`.

## Usage

On the host, you must *always* run `net-invoke.sh`:

    ./bin/net-invoke.sh

This is the "server"; it must be configured before using it:
* `NET_VISUAL`: path to visual text editor, defaults to `/cygdrive/c/Program Files/Sublime Text 3/sublime_text.exe`
* `NET_TERM`: path to terminal program, defaults to `mintty`


On the guest, the following commands are available:

* `s arg1 [arg2 ...]`: open an editor w/ the given argument(s)
* `term path`: open a new terminal window in path *path*
* `expl path`: open an *Explorer* window in path *path*


