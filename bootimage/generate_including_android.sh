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

########################################################################

if [ "$1" == "clean" ]; then
	pretty_header "Cleaning repository"
	
	#Android
	cd android 
	make clean
	cd ..
	
	#ramdisk
	cd build-files/ramdisk
	./modify_ramdisk.sh clean
	cd ../..
		
	./generate_without_android.sh clean
	
	echo_green "Cleaning repository done"
	
	exit 

elif [ "$1" != "only" ]; then
	./generate_without_android.sh
fi

cd ..

########################################################################

if [ ! -f repo ]; then

	pretty_header "Fetching repo"
	
	curl https://storage.googleapis.com/git-repo-downloads/repo > repo
	
	chmod +x repo
	
	echo_green "Fetching repo done"
	
fi

export PATH=$PATH:`pwd`

########################################################################

if [ ! -d android ]; then
	
	pretty_header "Fetching android source"
	
	mkdir android
	
	cd android
	
	repo init -u git://github.com/MentorEmbedded/mpsoc-manifest.git -b zynqmp-android_8 -m release_android-8_xilinx-v2018.1.xml
	
	repo sync -c
	
	cd ..
	
	echo_green "Fetching android source done"
	
fi

########################################################################

if [ ! -d android/vendor/xilinx/zynqmp/proprietary ]; then
	
	pretty_header "Fetching MALI 400 Userspace Binaries"
	
	cd build-files
	
	mkdir -p ../android/vendor/xilinx/zynqmp/proprietary 
	cp -r mali/* ../android/vendor/xilinx/zynqmp/proprietary/ 
	
	cd ..
	
	echo_green "Fetching MALI 400 Userspace Binaries done"
	
fi

########################################################################

if [ ! -f android/device/xilinx/zcu102/sepolicy/sv_startup.te ]; then

	pretty_header "Updating selinux policy files"
	
	cd build-files/sepolicy
	
	cp sv_startup.te ../../android/device/xilinx/zcu102/sepolicy/
	cp file_contexts ../../android/device/xilinx/zcu102/sepolicy/
	
	cd ../..
	
	echo_green "Updating selinux policy files done"
fi

########################################################################

if [ ! -d android/packages/apps/SoC ]; then

	pretty_header "Preparing client app"
	
	cd android
	
	mkdir packages/apps/SoC
	cp ../client/app/build/outputs/apk/debug/app-debug.apk packages/apps/SoC/SoC_Client.apk
	cp ../build-files/app/Android.mk packages/apps/SoC/
	cp ../build-files/app/core.mk build/target/product/
	
	cd ..

	echo_green "Preparing client app done"
fi

########################################################################

pretty_header "Making android"

cd android

source build/envsetup.sh

lunch zcu102-eng

make -j

cp out/target/product/zcu102/ramdisk.img ../build-files/ramdisk

cd ..

echo_green "Making android done"

########################################################################

pretty_header "Modify ramdisk.img"

cd build-files/ramdisk

./modify_ramdisk.sh extract
cp init.rc ramdisk/
mkdir -p ramdisk/lib/firmware
./modify_ramdisk.sh wrap
cp uramdisk.img ../../bootimage/

cd ../..

echo_green "Modify ramdisk.img done"
