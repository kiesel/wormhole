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
