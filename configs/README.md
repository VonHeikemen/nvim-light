# Configs

Each lua script in this directory is a configuration made for a specific version of Neovim.

* `v0-9.lua` requires NVIM v0.9 or greater
* `v0-10.lua` requires NVIM v0.10 or greater
* `v0-11.lua` requires NVIM v0.11 or greater
* `v0-12.lua` requires NVIM v0.12 or greater

You can check Neovim's version using this command.

```sh
nvim --version
```

Note that **NVIM v0.11** is the current stable version. **NVIM v0.12** is the "nightly version," which means is under active development.

## The nvim directory

Note that Neovim's configuration file should be called `init.lua`. The location of this file changes depending on your operating system, but these are the usual paths:

```
Unix       ~/.config/nvim/init.lua
Windows    ~/AppData/Local/nvim/init.lua
```

To know the exact path where your `init.lua` should live use this command on your terminal:

```sh
nvim --headless -c 'echo stdpath("config") . "\n"' -c 'quit'
```

Neovim does not create this directory automatically. You have to do that yourself.

## Why multiple configurations?

Maintaining one configuration that is backwards compatible with older versions means introducing complexity that doesn't feel right. And also forces me to lock plugins to a specific version, so that it works on macOS but also on Ubuntu and Windows.

Targeting one specific version at a time makes things easier. The price **you** have to pay is simply be aware of the Neovim version you are using and pick the correct file.

