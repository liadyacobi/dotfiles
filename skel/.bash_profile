# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

mkcd() {
	mkdir -p -- "$1" &&
      cd -P -- "$1"
}
# User specific environment and startup programs
