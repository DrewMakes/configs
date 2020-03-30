import XMonad
import XMonad.Config.Desktop

myBorderWidth = 0
myModMask = mod1Mask -- Alt
myTerminal = "alacritty"

main = xmonad desktopConfig
    {borderWidth = myBorderWidth
    ,modMask = myModMask
    ,terminal = myTerminal}
