#!/bin/bash
set -e

function echo_red   () { printf "\033[1;31m$*\033[m\n"; }
function echo_green () { printf "\033[1;32m$*\033[m\n"; }
function echo_blue  () { printf "\033[1;34m$*\033[m\n"; }

function pretty_header() {
		msg="# $* #"
		edge=$(echo "$msg" | sed 's/./#/g')
		echo
		echo_blue "$edge"
		echo_blue "$msg"
		echo_blue "$edge"
		echo
}

sh generate_without_android.sh

cd ..

if [ ! -f repo ]; then

	pretty_header "Fetching repo"
	
	curl https://storage.googleapis.com/git-repo-downloads/repo > repo
	
	chmod +x repo
	
	echo_green "Fetching repo done"
	
fi

export PATH=$PATH:`pwd`

if [ ! -d android ]; then
	
	pretty_header "Fetching android source"
	
	mkdir android
	
	cd android
	
	repo init -u git://github.com/MentorEmbedded/mpsoc-manifest.git -b zynqmp-android_8 -m release_android-8_xilinx-v2018.1.xml
	
	repo sync -c
	
	cd ..
	
	echo_green "Fetching android source done"
	
fi

pretty_header "Making android"

cd android

source build/envsetup.sh

lunch zcu102-eng

make -j

echo_green "Making android done"
