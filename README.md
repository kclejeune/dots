# HPC Dotfile Setup Tool

A set of non-sudo, HPC compatible dotfiles and config settings.

```bash
git clone https://github.com/kclejeune/dots.git --recursive
cd dots && ./install
```
To install necessary tools, run

```bash
./install-tools.sh
```

## Dotfile Symlinking

This project utilizes ![Dotbot](https://github.com/anishathalye/dotbot) for dotfile symlink management.
To relink dotfiles upon modification, re-run

```bash
./dots/install
```

