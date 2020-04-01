export PATH="$HOME/.cargo/bin:$PATH"

setxkbmap -option ctrl:nocaps

sxhkd &
exec bspwm
