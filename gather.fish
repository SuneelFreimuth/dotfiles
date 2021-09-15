# Gathers my dotfiles into the repository, making a new commit to register the change.

set files_to_commit

function grab_file
    mkdir --parents (dirname $argv[2])
    cp $argv[1] $argv[2]
    set files_to_commit $files_to_commit $argv[2]
end

grab_file ~/.xmonad/xmonad.hs ./xmonad/xmonad.hs
grab_file ~/.xmobarrc ./xmobar/.xmobarrc

# TODO: Make entries for...
#   ~/.config/nvim/init.vim
#   ~/.config/alacritty/alacritty.yml
#   ~/.config/conky/conky.conf
#   ~/.config/picom/picom.conf
#   /etc/acpi/handler.sh
#   ~/.config/fish/config.fish

git add $files_to_commit
git commit -m "Gather"
