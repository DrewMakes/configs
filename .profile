export PATH="$HOME/.cargo/bin:$PATH"
export SXHKD='/usr/bin/sh'

setxkbmap -option ctrl:nocaps

sxhkd &
exec bspwm
