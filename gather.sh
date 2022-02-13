#!/bin/sh
# Gathers my dotfiles into the repository, making a new commit to register the change.

files_to_commit=""

grab_file () {
	# grab_file in_file out_file
    mkdir --parents $(dirname $2)
    cp $1 $2
    files_to_commit="$files_to_commit $2"
}

grab_file ~/.config/nvim/init.vim ./neovim/init.vim

# grab_file ~/.xmonad/xmonad.hs ./xmonad/xmonad.hs
# grab_file ~/.xmobarrc ./xmobar/.xmobarrc

# TODO: Make entries for...
#   ~/.config/nvim/init.vim

git add $files_to_commit
git commit -m "Gather"

