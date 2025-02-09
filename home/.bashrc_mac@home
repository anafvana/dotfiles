# DIRECTORIES #
homeDirs=(".local/bin" "etc")
export DOTFILES="${HOME}/.dotfiles"
export HOMEFILES="${HOME}/.dotfiles/home"
export CONFIGFILES="${HOME}/.dotfiles/.config"
export SCRIPTS="${HOME}/.dotfiles/scripts"

# ADDITIONAL BASHRCs #
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

# LLVM #
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
# # Clang 12
# addToPath '/opt/homebrew/opt/llvm@12/bin'
# export LDFLAGS="-L/opt/homebrew/opt/llvm@12/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm@12/include"

# Clang latest
LDFLAGS="-L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++"

# C, GCC, CMAKE #
addToPath '/opt/homebrew/opt/arm-none-eabi-gcc@8/bin'
alias cflag='export CFLAGS="-arch arm64 ${CFLAGS:-}"'
# alias cmakeflag='export CMAKE_CXX_FLAGS="-stdlib=stdlibc++ ${CMAKE_CXX_FLAGS:-}"'
# alias clinkerflag='export CMAKE_EXE_LINKER_FLAGS="-stdlib=stdlibc++ ${CMAKE_EXE_LINKER_FLAGS:-}"'


# ALIASES #
alias psql='psql -h localhost -d postgres -U postgres -W'
alias rustr='evcxr'

# ADDITIONS TO PATH #
addToPath '/opt/homebrew/anaconda3/bin'
addToPath '/opt/homebrew/opt/node@18/bin'
addToPath '/usr/local/go/bin'
addToPath "$HOME/.local/bin"
addToPath "$HOME/.cargo/bin"

# AUTOMATIC CHANGES #
# changes made automatically by packages/programs
[ -f "/Users/a/.ghcup/env" ] && source "/Users/a/.ghcup/env" # ghcup-envaddToPath /Users/a/go/bin

# NO PATH DUPLICATES #
cleanPath
