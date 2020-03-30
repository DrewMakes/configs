set PATH $HOME/.cargo/bin $PATH

# use 'config' instead of 'git' when adding dotfiles to github
# $ config add filename.conf
# $ config commit -m '<message>'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
