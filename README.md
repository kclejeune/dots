# macOS Setup Tool

Contains a collection of packages and dotfiles for a variety of macOS utilities. To install on a new system, run:

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

