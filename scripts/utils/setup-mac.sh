# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew update

# Install window + shortcut manager
brew tap FelixKratz/formulae
brew install yabai shkd borders

# Install terminal
brew install --cask alacritty

# Install nvim and plugins
brew install neovim efm-langserver

brew upgrade
