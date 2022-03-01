#!/usr/bin/env bash
set -m

function italic_log() {
  echo -e "\e[3m$@\e[0m"
}

if [ "$EUID" -ne 0 ]; then
  italic_log "ERROR:"
  italic_log "To setup successfully, please run the script as root"
  italic_log "Try running: \"sudo !!\""
  exit 2
fi

USER_HOME=/home/$SUDO_USER

# Install Vim-Plug
su -c "curl -fLo $USER_HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -- $SUDO_USER

# Rename files in home dir
mv "$USER_HOME/.bashrc" "$USER_HOME/.bashrc.$(date)"
mv "$USER_HOME/.vimrc" "$USER_HOME/.vimrc.$(date)"

OMB_INSTALL=$(pwd)/omb.sh

# Install oh-my-bash
su -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh \
        -o $OMB_INSTALL)" -- $SUDO_USER
su -c "chmod u+x $OMB_INSTALL"
su -c "bash $OMB_INSTALL --unattended" -- $SUDO_USER
rm -f $OMB_INSTALL

# Copy all files to user home directory
su -c "cp ./skel/.??* $USER_HOME/" -- $SUDO_USER

# Vim setup
yum update -y
yum install -y python3 gcc gcc-c++ make epel-release ncurses ncurses-devel

yum install -y ctags git tcl-devel cmake3 ruby ruby-devel python-devel python3-devel

yum remove -y vim-enhanced vim-common vim-filesystem 2>/dev/null

# Create vim dir and clone vim from github
VIM_REPO_DIR=/usr/share/vim/repo
mkdir -p $VIM_REPO_DIR
git clone https://github.com/vim/vim.git $VIM_REPO_DIR

# Configuring Vim 8
cd $VIM_REPO_DIR && LDFLAGS=-rdynamic ./configure --with-features=huge \
  --enable-python3interp \
  --enable-multibyte \
  --enable-rubyinterp \
  --with-python3-config-dir=$(python3-config --configdir)

# Build and compile vim
make -C $VIM_REPO_DIR && make install -C $VIM_REPO_DIR

# Create link in bin dir
rm /bin/vim 2>/dev/null
ln -s $VIM_REPO_DIR/src/vim /bin/vim

# Install vim plugins
su -c "vim -E -s -u '$USER_HOME/.vimrc' +'PlugInstall --sync' +qa" -- $SUDO_USER

# Installing You Complete Me Tools
yum install -y centos-release-scl
yum-config-manager --enable rhel-server-rhscl-7-rpms
yum install -y devtoolset-8
scl enable devtoolset-8 bash
su -l -c "cd $USER_HOME/.vim/plugged/YouCompleteMe && ./install.py --all" -- $SUDO_USER

echo SUCCESS!!
echo "Now please source your .bashrc file: $(italic_log 'source ~/.bashrc')" 
