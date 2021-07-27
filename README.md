# HPC Dotfile Setup Tool

A set of non-sudo, HPC compatible dotfiles and config settings.

```bash
git clone https://github.com/kclejeune/system.git && ./system/preferences.sh && ./system/install && ./system/packages.sh
```

## Dotfile Symlinking

This project utilizes ![Dotbot](https://github.com/anishathalye/dotbot) for dotfile symlink management.
To relink dotfiles upon modification, re-run

```bash
./system/install
```

## Package Installation

This uses Homebrew Bundle for package installation.  Packages are kept in [Brewfile](./Brewfile).

