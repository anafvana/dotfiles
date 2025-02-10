# Dotfiles For Lazy Self

This README.md is under development (and will probably continue being under development for the next eternity).

## Setting up a new environment

> [!TIP]
> For Windows setups, see [Windows](#windows)

1. Symlink your bashrc to whichever `.bashrc_os@id` you want to use. Example

```bash
ln -s .dotfiles/home/.bashrc_mac@home $HOME/.bashrc
source $HOME/.bashrc
```

2. Run the script under `.dotfiles/scripts/setup.sh`

> [!WARNING]
> This is an interactive and it will output commands for you to run manually.

### Windows


> [!WARNING]
> The Windows set up is not integrated with other \*nix setups

1. Run `scripts/utils/setup-win.ps1`
2. Follow instructions at the end of script run

### `nvim`

Once the config is symlinked, you will need to sync packages.

Open `nvim` and run:

```
:PackerSync
```

Reopen `nvim` and check if all errors are gone.

#### Known issues

##### `hexokinase`

Hexokinase might say you need to run `make hexokinase` from the project root. If it does, run:

```
cd ~/.local/share/nvim/site/pack/packer/start/vim-hexokinase && make hexokinase
```

Check `:h hexokinase-installation` if you still have trouble.

##### `efm-langserver`

EFM language server might be unavailable. You'll need to install it through your package manager:

```bash
# ONE OF:
$ sudo apt install efm-langserver
$ brew install efm-langserver
$ npm install -g efm-langserver
```
