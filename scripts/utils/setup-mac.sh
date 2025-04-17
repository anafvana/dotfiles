echo "STARTING setup-mac.sh"

# Symlink bashrc
echo "Symlinking .zshrc"
rm "$HOME/.zshrc" &> /dev/null; ln -s "$HOME/.bashrc" "$HOME/.zshrc"

# Install newest bash
echo "Installing newest bash"
brew install bash
brew link bash
newBash="$(brew --prefix)/bin/bash"

# Add new login shell if not present
if ! grep -q "$newBash" /etc/shells; then
  sudo awk -v newBash="$newBash" '
    # Print the comments (lines starting with #)
    /^#/ { print; next }

    # When an empty line is found, print it, then add $newBash
    /^[[:space:]]*$/ && !added {
      print
      print newBash
      added = 1
      next
    }

    # Print everything else
    { print }
  ' /etc/shells > /tmp/shells.tmp && sudo mv /tmp/shells.tmp /etc/shells && rm /tmp/shells.tmp

fi

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