# GENERAL #
export VISUAL=nvim
export EDITOR="$VISUAL"

homeDirs=(".local/bin" "etc")
for dir in ${homeDirs[@]}
do
	if [ ! -d $HOME/$dir ]; then
    		mkdir $HOME/$dir
	fi
done

export BINARIES="${HOME}/${homeDirs[0]}"
export OTHER="${HOME}/${homeDirs[1]}"
export PATH="${PATH}:${BINARIES}"

# .dotfiles directories (autosetup files)
export DOTFILES="${HOME}/.dotfiles"
export HOMEFILES="${HOME}/.dotfiles/home"
export CONFIGFILES="${HOME}/.dotfiles/.config"
export SCRIPTS="${HOME}/.dotfiles/scripts"

# clean PATH duplicates
PATH=$(echo $PATH | tr ':' '\n' | perl -lne 'chomp; print unless $k{$_}; $k{$_}++' | tr '\n' ':' | sed 's/:$//')

# conditionally add directories to PATH
addToPath() {
	dir="$1"
	if [[ ! $PATH =~ "$dir" ]]
	then
		export PATH=$PATH:$dir
	fi
}

# If not running interactively, stop here
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
#setopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
#setopt -s checkwinsize

# autocd
setopt autocd

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# COLOURS #
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad
export GREP_OPTIONS='--color=auto'
export TERM="xterm-color"
# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# GOOGLE CLOUD #
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ana/etc/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ana/etc/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ana/etc/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ana/etc/google-cloud-sdk/completion.zsh.inc'; fi

# ALIASES #
ALIAS_FILES=(".aliases_git" ".aliases_pkgmgr")

for file in ${ALIAS_FILES[@]}
do
	if [ -f $HOMEFILES/$file ]; then
    		. $HOMEFILES/$file
    		source $HOMEFILES/$file
	fi
done

# other
alias v='nvim'
alias tar='tar -xvf'
alias ll='ls -l'
alias ll='ls -la'
alias psql='psql -h localhost -d hyttegruppen -U hgeier -W'
alias mongod='nohup mongod --dbpath "/opt/homebrew/var/mongodb"  &>/dev/null &'
alias pdfcompress='function _(){ if [ $# -eq 2 ]; then  "gs" -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$2 $1; else echo "Wrong number of arguments. Usage: pdfcompress [input.pdf] [output.pdf]"; fi }; _'

# AUTOMATIC CHANGES #
# changes made automatically by packages/programs
addToPath '/usr/local/go/bin'
addToPath '$HOME/etc'
addToPath '/opt/homebrew/opt/arm-none-eabi-gcc@8/bin'
[ -f "/Users/a/.ghcup/env" ] && source "/Users/a/.ghcup/env" # ghcup-envaddToPath /Users/a/go/bin

