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

This is simply achieved by placing a wormhole invoke into your `.bashrc` (or the respective file for your shell):

```sh
if [ ! -r /var/run/net-invoke.sh.pid ]; then
  echo "Starting wormhole server ..."
  WORMHOLE_REMOTE="/home/idev/" WORMHOLE_LOCAL="A:/" WORMHOLE_VISUAL="/cygdrive/c/Users/kiesel/OneDrive/applications/SublimeText3/sublime_text.exe" nohup $HOME/bin/net-invoke.sh </dev/null 2>&1 > $HOME/net-invoke.log &
  disown
fi
```

* Invoking with `nohup` disconnects the job from a `SIGHUP` signal in case your shell closes; this keeps the process on running
* Calling `disown` is necessary for zsh - so the process and its childs are disconnected and zsh won't complain about running background jobs - YMMV.

This is the "server"; it must be configured before using it:
* `WORMHOLE_REMOTE`: path to translate remote paths from
* `WORMHOLE_LOCAL`: path to translate remote paths to
* `WORMHOLE_PORT`: port to listen on (default `5115`)
* `WORMHOLE_VISUAL`: path to visual text editor, defaults to `/cygdrive/c/Program Files/Sublime Text 3/sublime_text.exe`
* `WORMHOLE_TERMINAL`: path to terminal program, defaults to `mintty`


On the guest, the following commands are available:

* `s arg1 [arg2 ...]`: open an editor w/ the given argument(s)
* `term path`: open a new terminal window in path *path*
* `expl path`: open an *Explorer* window in path *path*
* `start path`: start the file at *path* (like double-clicking it in Explorer)


