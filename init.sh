#!/usr/bin/env bash

function italic_log() {
  echo -e "\e[3m$@\e[0m"
}

if [ "$EUID" -ne 0 ]; then
  italic_log "ERROR:"
  italic_log "To setup successfully, please run the script as root"
  italic_log "Try running: \"sudo !!\""
  exit 2
fi

VERBOSE=0

while getopts 'v' flag; do
  case "${flag}" in
    v) VERBOSE='true' ;;
    *) print_usage
       exit 1 ;;
  esac
done

function log() {
    if [[ $verbose -eq 1 ]]; then
        italic_log "$@"
    fi
}

# Install Vim-Plug
log "Installing Vim-Plug"
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Rename files in home dir
log "Renaming .files to homedir ($HOME). renaming old files as $HOME/.<name>.old"
mv $HOME/.bashrc $HOME/.bashrc.$(date)
mv $HOME/.bash_profile $HOME/.bash_profile.$(date)
mv $HOME/.vimrc $HOME/.vimrc.$(date)

# Install oh-my-bash
log "Installing oh-my-bash"
curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh

# Copy all files to user home directory
log "Copying all dotfiles to homedir ($HOME)"
cp ./skel/.??* $HOME/
echo `cat ./skel/other_aliases` >> $HOME/.bashrc

# Source new files
log "Sourcing new files"
source $HOME/.bashrc
source $HOME/.bash_profile

# Vim setup
log "Installing Python3 and Compiling tools"
yum update -y
yum install -y python3 gcc make ncurses ncurses-devel

yum install -y ctags git tcl-devel ruby ruby-devel python-devel python3-devel

log "Removing existing vim installations"
yum remove -y vim-enhanced vim-common vim-filesystem 2>/dev/null

log "Cloning vim from git"
VIM_REPO_DIR=/usr/share/vim/repo
mkdir -p $VIM_REPO_DIR
git clone https://github.com/vim/vim.git $VIM_REPO_DIR

log "Configuring Vim 8"
LDFLAGS=-rdynamic $VIM_REPO_DIR/configure --with-features=huge \
  --enable-python3interp \
  --enable-multibyte \
  --enable-rubyinterp \

log "Build Vim"
cd $VIM_REPO_DIR && make

log "Install Vim"
cd $VIM_REPO_DIR && make install

log "Add vim to /bin"
ln -s $VIM_REPO_DIR/src/vim /bin/vim

log "Installed Vim:"
vim -version | head -n 1

log "Installing Vim Plugins"
vim -E -s -u "$HOME/.vimrc" +'PlugInstall --sync' +qa

log "Installing You Complete Me Tools"
su -u $USER "cd $HOME/.vim/plugged/YouCompleteMe && ./install.py --all"


