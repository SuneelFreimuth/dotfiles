# Xmobar Config

![Screenshot of my xmobar instance](./screenshot.png)

I run xmobar on both of my displays, spawning one process per display. My workspaces and active window title are provided by xmonad through xmobar's `UnsafeStdinReader`.

My [xmonad config](https://github.com/SuneelFreimuth/dotfiles/blob/main/xmonad/xmonad.hs) shows how I spawn multiple xmobar instances and pretty-print the data to each xmobar process.
