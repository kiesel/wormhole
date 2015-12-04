# Wormhole

## About
Imagine this: you have a host OS and a virtualized guest; all development takes place on the guest; filesystems are mounted from guest to host, but when you ssh into the guest, there is no effective way of opening a modern editor, or a shell or new terminal.

Wormhole is here to fix that.

## Installation

You'll need to install wormhole on both, the guest and the host system. There are multiple ways to do it:

### Installation via antigen

* `antigen bundle kiesel/wormhole`

### Installation via zgen

* Put `zgen load kiesel/wormhole` into the *zgen* block in your `.zshrc`

### Manual installation (or oh-my-zsh)

Clone the git repository to some place; for oh-my-zsh, put it into $(ZSH_CUSTOM)

```sh
git clone https://github.com/kiesel/wormhole.git
```

Then, source the `wormhome.plugin.zsh` entrypoint script from your `.zshrc` or `.bashrc`; if you've put the checkout into the $(ZSH_CUSTOM) directory, you can omit the manual sourcing, oh-my-zsh will do it for you:

```sh
source $(HOME)/path/to/wormhole/wormhole.plugin.zsh
```

## Configuration

Only the **host** part needs configuration! There are several environment variables that need to be configured (some have defaults):

* `WORMHOLE_REMOTE`: path to translate remote paths from
* `WORMHOLE_LOCAL`: path to translate remote paths to
* `WORMHOLE_PORT`: port to listen on (default `5115`)
* `WORMHOLE_EDITOR`: path to visual text editor, defaults to `/cygdrive/c/Program Files/Sublime Text 3/sublime_text.exe`
* `WORMHOLE_TERMINAL`: path to terminal program, defaults to `mintty`

The configuration variables need to be set **prior** the source line in your .*rc file.

## Usage

On the host, when first opening a shell, the wormhole server starts; closing the shell will leave it running. Any further shell starts will not start further wormhole processes *unless* the running process has died. The server will write a logfile to `$(HOME)/wormhole.log`.

On the guest, the following commands are available:

* `s <path> [...]`: open an editor w/ the given argument(s)
* `term <path>`: open a new terminal window in path *path*
* `expl <path>`: open an *Explorer* window in path *path*
* `start <path>`: start the file at *path* (like double-clicking it in Explorer)


