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

#~ sh generate_without_android.sh

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

if [ ! -d android/vendor/xilinx/zynqmp/proprietary ]; then
	
	pretty_header "Fetching MALI 400 Userspace Binaries"
	
	cd build-files
	
	mkdir -p ../android/vendor/xilinx/zynqmp/proprietary 
	cp -r mali/* ../android/vendor/xilinx/zynqmp/proprietary/ 
	
	cd ..
	
	echo_green "Fetching MALI 400 Userspace Binaries done"
	
fi

#TODO:
#Modify selinux policy
#android/device/xilinx/zcu102/sepolicy
# - file_contexts
# - sv_startup.te 

pretty_header "Making android"

cd android

source build/envsetup.sh

lunch zcu102-eng

make -j

echo_green "Making android done"

#TODO:
#Modify ramdisk.img
