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

# Easily execute tasks as the user who executed the script with the 'sudo' command
function as_user() {
  su -c '$@' -- $SUDO_USER
}
USER_HOME=/home/$SUDO_USER

# Install Vim-Plug
su -c "curl -fLo $USER_HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -- $SUDO_USER

# Rename files in home dir
mv "$USER_HOME/.bashrc" "$USER_HOME/.bashrc.$(date)"
mv "$USER_HOME/.bash_profile" "$USER_HOME/.bash_profile.$(date)"
mv "$USER_HOME/.vimrc" "$USER_HOME/.vimrc.$(date)"


# Install oh-my-bash
su -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" -- $SUDO_USER

# Copy all files to user home directory
su -c "cp ./skel/.??* $USER_HOME/" -- $SUDO_USER

# Vim setup
yum update -y
yum install -y python3 gcc make ncurses ncurses-devel

yum install -y ctags git tcl-devel ruby ruby-devel python-devel python3-devel

yum remove -y vim-enhanced vim-common vim-filesystem 2>/dev/null

# Create vim dir and clone vim from github
VIM_REPO_DIR=/usr/share/vim/repo
mkdir -p $VIM_REPO_DIR
git clone https://github.com/vim/vim.git $VIM_REPO_DIR

# Configuring Vim 8
LDFLAGS=-rdynamic $VIM_REPO_DIR/configure --with-features=huge \
  --enable-python3interp \
  --enable-multibyte \
  --enable-rubyinterp \
  --with-python3-config-dir=$(python3-config --configdir)

# Build and compile vim
cd $VIM_REPO_DIR && make && make install

# Create link in bin dir
rm /bin/vim 2>/dev/null
ln -s $VIM_REPO_DIR/src/vim /bin/vim

# Install vim plugins
su -c "vim -E -s -u '$USER_HOME/.vimrc' +'PlugInstall --sync' +qa" -- $SUDO_USER

# Installing You Complete Me Tools
su -c "cd $USER_HOME/.vim/plugged/YouCompleteMe && ./install.py --all" -- $SUDO_USER

echo SUCCESS!!
echo "Now please source your .bashrc file: $(italic_log source ~/.bashrc)" 
