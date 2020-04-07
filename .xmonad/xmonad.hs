{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TypeSynonymInstances #-}

import qualified Codec.Binary.UTF8.String as UTF8
import Data.Monoid

import XMonad
import qualified Data.Map as M
import Data.List
import Graphics.X11.ExtraTypes.XF86
import XMonad.Actions.CycleWS
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageHelpers
import qualified XMonad.Layout.Fullscreen as FS
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.DynamicLog
import System.IO
import Control.Monad
import qualified XMonad.StackSet as W

import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Hooks.ManageDocks
import XMonad.Config.Desktop
import XMonad.Util.SpawnOnce

-- Make our own Picture-in-Picture mode
import XMonad.Config.Prime (LayoutClass)
import Graphics.X11 (Rectangle(..))

data PiP a = PiP deriving (Show, Read)

mkpip rect@(Rectangle sx sy sw sh) (master:snd:ws) = [small, (master, rect)]
  where small = (snd, (Rectangle px py pw ph))
        px = sx + fromIntegral sw - fromIntegral pw - 32
        py = sy + fromIntegral sh - fromIntegral ph - 32
	pw = sw `div` 4
	ph = sh `div` 4
mkpip rect (master:ws) = [(master, rect)]
mkpip rect [] = []

instance LayoutClass PiP a where
    pureLayout PiP rect stack = mkpip rect ws
      where ws = W.integrate stack

    description _ = "PiP"


myBorderWidth = 0
myModMask = mod1Mask -- Alt
myWorkspaces = ["web","a","b","c","long","mx","sfx"]
myTerminal = "alacritty"

myLayout = tiled ||| (Mirror tiled) ||| Full ||| PiP
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = toRational (2 / (1 + sqrt 5 :: Double))

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "Gimp"           --> doFloat
    , className =? "transmission-gtk" --> doFloat
    , className =? "mpv" --> doFloat
    , fmap (isInfixOf "Pinentry") className --> doFloat
    , fmap (isInfixOf "MATLAB") className <&&> fmap (not . isInfixOf "MATLAB") (stringProperty "WM_NAME") --> doFloat
    , fmap (isInfixOf "show.py") (stringProperty "WM_NAME") --> doFullFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , className =? "kupfer.py"      --> doIgnore
    , className =? "foobar"      --> doShift "sfx"
    , title =? "foobar"      --> doShift "sfx"
    , fmap (isInfixOf "display") appCommand --> doFloat
    , fmap (isInfixOf "feh") appCommand --> doFloat
    --, (className =? "" <&&> title =? "") --> doShift "sfx" -- Spotify: https://bbs.archlinux.org/viewtopic.php?id=204636
    , (stringProperty "WM_WINDOW_ROLE" =? "GtkFileChooserDialog") --> doFullFloat
    , isFullscreen                  --> doFullFloat
    , FS.fullscreenManageHook
    ]
    where
    appCommand = stringProperty "WM_COMMAND"
    --doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift

myStartupHook = do
  spawnOnce "$Home/.config/polybar/launch.sh"

-------------------------------------------------------
main = do
    xmonad $ desktopConfig {
        borderWidth = myBorderWidth,
        modMask = myModMask,
	workspaces = myWorkspaces,
        terminal = myTerminal,
	layoutHook = desktopLayoutModifiers $ noBorders $ myLayout,
	manageHook = myManageHook <+> manageHook desktopConfig,
        startupHook = myStartupHook <+> startupHook desktopConfig
     }
