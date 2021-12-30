export CONFIGFILES=/home/ana/.dotfiles/.config
export SCRIPTS=/home/ana/.dotfiles/scripts
export HOMEFILES=/home/ana/.dotfiles/home
export DOTFILES=/home/ana/.dotfiles
# GENERAL #
export VISUAL=nvim
export EDITOR="$VISUAL"

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

#Autocd
shopt -s autocd

#Run programs

# User specific aliases and functions

## Functions

_complete_ssh_hosts (){
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
                    cut -f 1 -d ' ' | \
                    sed -e s/,.*//g | \
                    grep -v ^# | \
                    uniq | \
                    grep -v "\[" ;
            cat ~/.ssh/config | \
                    grep "^Host " | \
                    awk '{print $2}'
            `
    COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
    return 0
}
complete -F _complete_ssh_hosts ssh

### Connectivity functions
function db(){
	output=`ps aux | grep "30000:thales:3306"`
	if [[ "$output" != *"ssh -f pythagoras -L 30000:thales:3306 -N"* ]]
	then
		ssh -f pythagoras -L 30000:thales:3306 -N
	fi
	mysql -h 127.0.0.1 --port=30000 -u mysql -p autopoint -A
}

## Aliases
alias pythagoras='ssh -tX pythagoras'
alias euler1='ssh -t euler1'
alias euler2='ssh -t euler2'
alias euler3='ssh -t euler3'
alias pascal='ssh -t pascal ". /home/mrexec/ana/setup.sh;bash -l"'

ALIAS_FILES=(".aliases_git" ".aliases_pkgmgr")

for file in ${ALIAS_FILES[@]}
do
	if [ -f $HOMEFILES/$file ]; then
    		. $HOMEFILES/$file
    		source $HOMEFILES/$file
	fi
done

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias v='nvim'

alias opoint="cd $HOME/Insync/anafvana@gmail.com/Google\ Drive/Opoint"
alias .bashrc="nvim $HOME/.bashrc"
alias sourch="source $HOME/.bashrc"

# AUTOMATICALLY ADDED #
. "$HOME/.cargo/env"
export PATH=$PATH:/usr/local/go/bin
