# Configs

Each lua script in this directory is a configuration made for a specific version of Neovim.

* `stable.lua` requires NVIM v0.11 or greater
* `nightly.lua` targets NVIM v0.12, the current "nightly version" 

You can check Neovim's version using this command.

```sh
nvim --version
```

If you need support for older Neovim versions:

* `v0-5.lua` targets NVIM v0.5 and v0.6
* `v0-7.lua` targets NVIM v0.7 and v0.8
* `v0-9.lua` targets NVIM v0.9 and v0.10

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

