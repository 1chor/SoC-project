#!/bin/bash

function echo_red   () { printf "\033[1;31m$*\033[m\n"; }
function echo_green () { printf "\033[1;32m$*\033[m\n"; }
function echo_blue  () { printf "\033[1;34m$*\033[m\n"; }

function usage () {
	echo_red "Usage: $0 [clean/extract/wrap/help]"
	echo 
	echo_red "clean   - removes old generated files"
	echo 
	echo_red "unwrap  - unwrap the image with the u-boot header"
	echo 
	echo_red "extract - extract image file"
	echo 
	echo_red "wrap    - wrap the image with u-boot header"
	echo 
	echo_red "help    - Prints this message"
	exit 1 ;
}

function check_option() {
	local opt=$1
	case $opt in
		clean)
			clean="y"
			;;
		unwrap)
			unwrap="y"
			;;
		extract) 
			extract="y"
			;;
		wrap) 
			wrap="y"
			;;
		help)
			usage
			;;
		*)
			usage
			;;
	esac
}

########################################################################

for opt in $@ ; do # checks all arguments
	check_option $opt
done

if [ "$clean" = "y" ]; then

	#remove old image files
	if [ -f uramdisk.img ]; then
		rm uramdisk.img
	fi
	
	if [ -f ramdisk.img ]; then
		rm ramdisk.img
	fi
	
	#remove old extracted ramdisk
	if [ -d ramdisk ]; then
		rm -rf ramdisk
	fi

fi

if [ "$unwrap" = "y" ]; then

	# remove old ramdisk.img
	if [ -f ramdisk.img ]; then
		rm ramdisk.img
	fi
	
	# unwrap image with the u-boot header
	dd if=uramdisk.img bs=64 skip=1 of=ramdisk.img

	# remove old uramdisk.img
	if [ -f uramdisk.img ]; then
		rm uramdisk.img
	fi
	
fi

if [ "$extract" = "y" ]; then

	#remove old extracted ramdisk
	if [ -d ramdisk ]; then
		rm -rf ramdisk
	fi
	
	mkdir ramdisk
	
	# extract image file
	gunzip -cN ramdisk.img | cpio -idm --no-preserve-owner -D ramdisk

	# remove old ramdisk.img
	if [ -f ramdisk.img ]; then
		rm ramdisk.img
	fi

fi

if [ "$wrap" = "y" ]; then

	# create image file
	cd ramdisk
	find . | cpio -H newc -o | gzip -9 > ../ramdisk.img
	cd ..

	# wrapping the image with the u-boot header
	../../mpsoc-u-boot-xlnx/tools/mkimage -A arm64 -T ramdisk -n "RAM Disk" -C gzip -d ramdisk.img uramdisk.img

fi
