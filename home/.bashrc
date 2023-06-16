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


# GOOGLE CLOUD #
if [ -f '/Users/ana/etc/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ana/etc/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/Users/ana/etc/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ana/etc/google-cloud-sdk/completion.zsh.inc'; fi


# PATH ADDITIONS #
find /Applications -maxdepth 2 | grep \.app$ | while read filename
do
	if [ -d "$filename/Contents/MacOS" ]
	then
		line="$filename/Contents/MacOS"
		line=${line// /\\ }
		addToPath "$line"
	fi
done

addToPath '/opt/homebrew/opt/arm-none-eabi-gcc@8/bin'
addToPath '/opt/homebrew/anaconda3/bin'
addToPath '/opt/homebrew/opt/node@18/bin'
addToPath '/usr/local/go/bin'


# OTHER ALIASES #
alias psql='psql -h localhost -d postgres -U postgres -W'


# AUTOMATIC CHANGES #
# changes made automatically by packages/programs
[ -f "/Users/a/.ghcup/env" ] && source "/Users/a/.ghcup/env" # ghcup-envaddToPath /Users/a/go/bin

# NO PATH DUPLICATES #
cleanPath
