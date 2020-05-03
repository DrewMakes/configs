# export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin:$(du "$HOME/.scripts/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export SXHKD='/usr/bin/sh'

# Default programs:
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="firefox"
export READER="zathura"
export FILE="lf"

# ~/ Clean-up
export ZDOTDIR="$HOME/.config/zsh"

# Capslock to Super/hold and Escape/press
setxkbmap -option caps:super
killall xcape 2>/dev/null ; xcape -e 'Super_L=Escape'

sxhkd &
exec bspwm
