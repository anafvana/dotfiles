# DIRECTORIES #
homeDirs=(".local/bin" "etc")
export DOTFILES="${HOME}/.dotfiles"
export HOMEFILES="${HOME}/.dotfiles/home"
export CONFIGFILES="${HOME}/.dotfiles/.config"
export SCRIPTS="${HOME}/.dotfiles/scripts"


# ALIASES #
GENERIC_BASH="${HOMEFILES}/.bashrc_generic"
if [ -f "$GENERIC_BASH" ]; then
    . $GENERIC_BASH
    source $GENERIC_BASH
fi

MAC_BASH="${HOMEFILES}/.bashrc_mac"
if [ -f "$MAC_BASH" ]; then
    . $MAC_BASH
    source $MAC_BASH
fi

# GOOGLE CLOUD #
if [ -f '/Users/ana/etc/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ana/etc/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/Users/ana/etc/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ana/etc/google-cloud-sdk/completion.zsh.inc'; fi
export CLOUDSDK_PYTHON_SITEPACKAGES=1

# GITHUB IDENTITY SWITCHING #
ssh="$HOME/.ssh"
main_ssh="id_rsa"
anafvana="anafvana@github"
anacdc="ana-cdc"

function ghcdc(){
	cp "$ssh/$anacdc" "$ssh/$main_ssh"
	cp "$ssh/$anacdc.pub" "$ssh/$main_ssh.pub"
	echo "SSH key is ana-cdc"
}

function ghana(){
	cp "$ssh/$anafvana" "$ssh/$main_ssh"
	cp "$ssh/$anafvana.pub" "$ssh/$main_ssh.pub"
	echo "SSH key is anafvana"
}

# OTHER ALIASES #
alias psql='psql -h localhost -d postgres -U postgres -W'


# AUTOMATIC CHANGES #
# changes made automatically by packages/programs
[ -f "/Users/a/.ghcup/env" ] && source "/Users/a/.ghcup/env" # ghcup-envaddToPath /Users/a/go/bin

# NO PATH DUPLICATES #
cleanPath
