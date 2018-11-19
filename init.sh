#!/bin/bash

ROOTDIR=$HOME/.local

############## functions ######################
clearRootDir(){
	read -p "This will remove existing files in ~/.local directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		rm -rf $ROOTDIR
	else
		unset $ROOTDIR
		echo "Abort"
		exit 1
	fi;
}
##############################################

# create root directory
if [ -d "$HOME/.local" ]; then
        clearRootDir
fi
mkdir $ROOTDIR

# clone git repository
git clone http://45.40.196.100:10080/valley/dotfiles.git $ROOTDIR

# run install.sh
. $ROOTDIR/install.sh

unset $ROOTDIR
