#!/bin/bash

function echo_red   () { printf "\033[1;31m$*\033[m\n"; }
function echo_green () { printf "\033[1;32m$*\033[m\n"; }
function echo_blue  () { printf "\033[1;34m$*\033[m\n"; }

function usage () {
	echo_red "Usage: $0 [extract/wrap/help]"
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

if [ "$unwrap" = "y" ]; then

	# unwrap image with the u-boot header
	dd if=uramdisk.img bs=64 skip=1 of=ramdisk.img

	# rename old uramdisk.img
	mv "uramdisk.img" "uramdisk_old.img"

fi

if [ "$extract" = "y" ]; then

	mkdir ramdisk
	
	# extract image file
	gunzip -cN ramdisk.img | cpio -idm --no-preserve-owner -D ramdisk

	# rename old ramdisk.img
	mv ramdisk.img ramdisk_old.img

fi

if [ "$wrap" = "y" ]; then

	# create image file
	cd ramdisk
	find . | cpio -H newc -o | gzip -9 > ../ramdisk.img
	cd ..

	# wrapping the image with the u-boot header
	../../mpsoc-u-boot-xlnx/tools/mkimage -A arm64 -T ramdisk -n "RAM Disk" -C gzip -d ramdisk.img uramdisk.img

fi
