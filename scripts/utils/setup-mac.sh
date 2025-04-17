echo "STARTING setup-mac.sh"

# Symlink bashrc
echo "Symlinking .zshrc and .bash_profile"
rm "$HOME/.zshrc" &> /dev/null; ln -s "$HOME/.bashrc" "$HOME/.zshrc"
rm "$HOME/.bash_profile" &> /dev/null; ln -s "$HOME/.bashrc" "$HOME/.bash_profile"

# Install brew
echo "Installing brew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
source ~/.zshrc

# Install base tools for interactive setup
echo "Installing required packages"
brew install python go
python3 -m pip install virtualenv
brew update

echo "COMPLETED setup-mac.sh"