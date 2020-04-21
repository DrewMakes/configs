export PATH="$HOME/.cargo/bin:$PATH"
export SXHKD='/usr/bin/sh'

#remapSuper script: remap the Caslock to Super key (i3wm uses a lot Super key) 
setxkbmap -option caps:super

#remapEsc script: But when it is pressed only once, treat it as escape (Vim uses a lot exit)
killall xcape 2>/dev/null ; xcape -e 'Super_L=Escape'

sxhkd &
exec bspwm
