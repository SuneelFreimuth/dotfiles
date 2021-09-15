import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.MultiColumns
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableTile
import XMonad.Layout.Grid
import XMonad.Layout.GridVariants
import XMonad.Util.NamedScratchpad
import XMonad.Util.Scratchpad
import XMonad.Util.CustomKeys
import XMonad.Util.Run (spawnPipe)
import XMonad.StackSet as W
import XMonad.Layout.IndependentScreens
import XMonad.Util.Loggers

import System.IO

import qualified Data.Map as Map
import Data.Maybe
import Data.String
import Data.List
import Data.Monoid

main = do
    n <- countScreens
    xmbprocs <- mapM (\i -> spawnPipe $ "xmobar -x " ++ show i) [0..n-1]
    xmonad $ docks $ defaultConfig
        { terminal = myTerm
        , focusedBorderColor = "#5a91e2"
        , normalBorderColor = "#333"
        , borderWidth = 1
        , modMask = mod4Mask
        , keys = myKeys
        , logHook = myLogHook xmbprocs
        , layoutHook = myLayoutHook
        , manageHook = myManageHook
        }

---------------------------------------------------------------------------

myLogHook xmbprocs = mapM_ configurePP xmbprocs
    where
        configurePP xmbproc =
            dynamicLogWithPP $
            xmobarPP
                { ppOutput  = hPutStrLn xmbproc . removeSequence "NSP"
                , ppCurrent = colorActive . padIfSmall . romanize
                , ppVisible = padIfSmall . romanize
                , ppHidden  = colorDimmed . padIfSmall . romanize
                , ppTitle   = colorNormal
                , ppSep = colorDimmed "| "
                , ppOrder = \(ws:l:t:ex) -> [ws, t] ++ ex
                }

padIfSmall s =
    if length s == 1
        then pad s
        else s

colorActive = xmobarColor "#000" "#c3e88d"
colorNormal = xmobarColor "#FFF" ""
colorDimmed = xmobarColor "#888" ""

-- For example:
--   Prelude> removeSequence "and" "1 and 2 and 3!"
--   "1  2  3!"
removeSequence :: Eq a => [a] -> [a] -> [a]
removeSequence _ [] = []
removeSequence sequence li =
    case (stripPrefix sequence li) of
        Just rest -> removeSequence sequence rest
        Nothing -> (head li : removeSequence sequence (tail li))

romanize s = Map.findWithDefault s s romans

romans =
    Map.fromList [
        ("1",  "I"),
        ("2",  "II"),
        ("3",  "III"),
        ("4",  "IV"),
        ("5",  "V"),
        ("6",  "VI"),
        ("7",  "VII"),
        ("8",  "VIII"),
        ("9",  "IX"),
        ("10", "X")
    ]

myTerm = "WINIT_X11_SCALE_FACTOR=1 alacritty"

myLayoutHook = avoidStruts $ myLayouts

myLayouts = myFull ||| myTall
    where
        vertMargin = 6
        horMargin  = 9
        screenBorder = (Border vertMargin vertMargin horMargin horMargin)
        windowBorder = (Border vertMargin vertMargin horMargin horMargin)
        spacer     = spacingRaw True screenBorder True windowBorder True 
        myFull     = noBorders Full
        myTall     = spacer $ ResizableTall 1 (3/100) (1/2) []
        myThreeCol = spacer $ ThreeCol 1 (3/100) (1/2)

myKeys = customKeys delkeys inskeys
    where
        delkeys XConfig {modMask = modm}        = []
        inskeys conf@(XConfig {modMask = modm}) =
            [ ((modm .|. shiftMask, xK_s), spawn "maim --hidecursor --select --format=png | xclip -selection clipboard -target image/png")
            , ((modm .|. shiftMask, xK_b), spawn "brave")
            , ((modm .|. shiftMask, xK_v), spawn "code")
            , ((modm .|. shiftMask, xK_d), spawn "discord")
            , ((modm .|. shiftMask, xK_t), spawn "brave https://todoist.com/app/upcoming")
            , ((modm .|. shiftMask, xK_n), spawn "brave --app=https://notion.so")

            , ((modm,               xK_p), spawn "rofi -show run")
            , ((modm,               xK_a), sendMessage MirrorExpand)
            , ((modm,               xK_z), sendMessage MirrorShrink)
            , ((modm,               xK_g), toggleScreenSpacingEnabled >> toggleWindowSpacingEnabled)
            , ((modm,               xK_m), namedScratchpadAction myScratchpads "pulsemixer")
            , ((modm,               xK_o), namedScratchpadAction myScratchpads "floating-term")
            , ((modm,               xK_b), namedScratchpadAction myScratchpads "bluetoothctl")
            , ((modm,               xK_s), namedScratchpadAction myScratchpads "spotify")
            , ((modm,               xK_d), namedScratchpadAction myScratchpads "todoist")
            , ((modm,               xK_v), namedScratchpadAction myScratchpads "SimpleScreenRecorder")
            ]


myManageHook =
    manageDocks <+>
    manageHook defaultConfig <+>
    namedScratchpadManageHook myScratchpads


myScratchpads :: [NamedScratchpad]
myScratchpads =
    [ NS "pulsemixer" (myTerm ++ " --class pmix --command pulsemixer")
        (resource =? "pmix")
        layout
    , NS "floating-term" (myTerm ++ " --class floating-term")
        (resource =? "floating-term")
        layout
    , NS "bluetoothctl" (myTerm ++ " --class bluetoothctl --command bluetoothctl")
        (resource =? "bluetoothctl")
        layout
    , NS "spotify" "spotify"
        (resource =? "spotify")
        layout
    , NS "todoist" "brave --app=https://todoist.com/app/upcoming"
        (resource =? "todoist.com__app_upcoming")
        layout
    , NS "SimpleScreenRecorder" "simplescreenrecorder"
        (className =? "SimpleScreenRecorder")
        smallLayout
    ] where
        -- Math to leave horizontal and vertical gaps of the given proportions.
        xGap   = 1/5
        yGap   = 1/7
        layout = customFloating $
            W.RationalRect xGap yGap (1-2*xGap) (1-2*yGap)
        smallLayout = customFloating $
            W.RationalRect (2/5) (1/5) (1-2*2/5) (1-2*1/5)
