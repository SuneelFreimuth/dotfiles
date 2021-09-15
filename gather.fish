#
# Gathers my dotfiles into the repository, making a new commit to register the change.
# 

# set files_to_commit ""

mkdir --parents ./xmonad
cp ~/.xmonad/xmonad.hs ./xmonad/xmonad.hs
set files_to_commit ./xmonad/xmonad.hs

mkdir --parents ./xmobar
cp ~/.xmobarrc ./xmobar/.xmobarrc
set files_to_commit $files_to_commit ./xmobar/.xmobarrc

git add $files_to_commit
git commit -m "Gather"
