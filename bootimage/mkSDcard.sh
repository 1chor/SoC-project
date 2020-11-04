#!/bin/bash

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

function usage () {
	echo_red "Usage: $0 /dev/diskname [populate/eject/help]"
	echo 
	echo_red "populate   - The partitions will be populated with data"
	echo 
	echo_red "eject      - The SD card will be ejected automatically"
	echo 
	echo_red "help       - Prints this message"
	exit 1 ;
}

function usage_insufficient_args() {
	echo_red "Insufficient arguments"
	usage
}

function command_exists() {
	local cmd=$1
	[ -n "$cmd" ] || return 1
	type "$cmd" >/dev/null 2>&1
}

function removable_disks() {
	for f in `ls /dev/disk/by-path/* | grep -v part` ; do
		diskname=$(basename `readlink $f`)
		type=`cat /sys/class/block/$diskname/device/type`
		size=`cat /sys/class/block/$diskname/size`
		issd=0
		# echo "checking $diskname/$type/$size"
		if [ $size -ge 3906250 ]; then
			if [ $size -lt 62500000 ]; then
				issd=1
			fi
		fi
		if [ "$issd" -eq "1" ]; then
			echo -n "/dev/$diskname "
			# echo "removable disk /dev/$diskname, size $size, type $type"
			#echo -n -e "\tremovable? " ; cat /sys/class/block/$diskname/removable
		fi
	done
	echo
}

function check_option() {
	local opt=$1
	case $opt in
		populate) 
			populate="1"
			;;
		eject) 
			eject="1"
			;;
		help)
			usage
			;;
		*)
			diskname=$opt
			;;
	esac
}

########################################################################

for cmd in sudo fdisk ; do # checks whether the commands are installed
	command_exists $cmd || {
		echo_red "Script requires '$cmd' installed on system"
		exit 1
	}
done

[ -n "$1" ] || usage_insufficient_args # checks if one argument is available

for opt in $@ ; do # checks all arguments
	check_option $opt
done

product=zcu102

pretty_header "Build SD card for product $product"

removables=`removable_disks`

for disk in $removables ; do # search for removable disks
	echo "Found available removable disk: $disk"
	if [ "$diskname" = "$disk" ]; then
		matched=1
		break
	fi
done

if [ -z "$matched" -a -z "$force" ]; then # checks if disk is valid
	if [ "${diskname:5:6}" == "mmcblk" ]; then
		echo_blue "mmcblk not seen as removable but will try it anyway"
	else
		echo_red "Invalid disk $diskname"
		exit -1;
	fi
fi

prefix='';

if [[ "$diskname" =~ "mmcblk" ]]; then
	prefix=p
fi

echo "reasonable disk $diskname, partitions ${diskname}${prefix}1..."

umount ${diskname}${prefix}*

pretty_header "Creating partition table"
parted -s ${diskname} mklabel msdos

pretty_header "Creating BOOT partition"
parted -s --align=optimal ${diskname} mkpart primary 4MiB 132MiB

pretty_header "Creating ROOT partition"
parted -s --align=optimal ${diskname} mkpart primary 132MiB 260MiB

# Making extended partition. Reserve 3GiB. 
# It will contain system and cache partitions for now.
# Additional misc. partitions (vendor, misc) should be placed
# on this extended partition after cache.
parted -s --align=optimal ${diskname} mkpart extended 260MiB 3332MiB

pretty_header "Creating SYSTEM partition"
parted -s --align=optimal ${diskname} mkpart logical 264MiB 2312MiB

pretty_header "Creating CACHE partition"
parted -s --align=optimal ${diskname} mkpart logical 2316MiB 2828MiB

pretty_header "Creating DATA partition"
parted -s --align=optimal ${diskname} mkpart primary 3332MiB 100%

sync
sleep 1

for n in `seq 1 6` ; do
	if ! [ -e ${diskname}${prefix}$n ] ; then
		echo_red "!!! Error: missing partition ${diskname}${prefix}$n"
		exit 1;
	fi
	sync
done

echo_green "Creating partitions done"

pretty_header "Formating BOOT partition"
mkfs.vfat -F 32 -n BOOT ${diskname}${prefix}1

pretty_header "Formating ROOT partition"
mkfs.ext4 -F -L ROOT ${diskname}${prefix}2

pretty_header "Formating SYSTEM partition"
mkfs.ext4 -F -L SYSTEM ${diskname}${prefix}5

pretty_header "Formating CACHE partition"
mkfs.ext4 -F -L CACHE ${diskname}${prefix}6

pretty_header "Formating DATA partition"
mkfs.ext4 -F -L DATA ${diskname}${prefix}4

echo_green "Formating partitions done"

if [ $populate ]; then
	pretty_header "Populating BOOT partition"
	if [ -e ${diskname}${prefix}1 ]; then
		mkdir -p /tmp/$$/boot_part
		mount -t vfat ${diskname}${prefix}1 /tmp/$$/boot_part
		cp -rfv BOOT.BIN /tmp/$$/boot_part/
		cp -rfv Image /tmp/$$/boot_part/
		cp -rfv *.dtb /tmp/$$/boot_part/
		cp -rfv ../android/out/target/product/$product/boot/uEnv.txt /tmp/$$/boot_part/uEnv.txt
		cp -rfv uramdisk.img /tmp/$$/boot_part/uramdisk.img
		sync
		umount /tmp/$$/boot_part
		rm -rf /tmp/$$/boot_part
	else
	   echo_red "!!! Error: missing BOOT partition ${diskname}${prefix}1";
	   exit 1
	fi

	pretty_header "Populating SYSTEM partition"
	if [ -e ${diskname}${prefix}5 ]; then
		sudo dd if=../android/out/target/product/$product/system.img of=${diskname}${prefix}5
		sudo e2label ${diskname}${prefix}5 SYSTEM
		sudo e2fsck -f ${diskname}${prefix}5
		sudo resize2fs ${diskname}${prefix}5
	else
		echo_red "!!! Error: missing SYSTEM partition ${diskname}${prefix}5";
		exit 1
	fi
	
	pretty_header "Populating DATA partition"
	if [ -e ${diskname}${prefix}4 ]; then
		mkdir -p /tmp/$$/data_part
		mount -t ext4 ${diskname}${prefix}4 /tmp/$$/data_part
		cp -rfv ../build-files/startup.sh /tmp/$$/data_part/
		mkdir -p /tmp/$$/data_part/modules
		cp -rfv modules/*.ko /tmp/$$/data_part/modules/
		cp -rfv ../client/Root_Client.sh /tmp/$$/data_part/
		sync
		umount /tmp/$$/data_part
		rm -rf /tmp/$$/data_part
	else
	   echo_red "!!! Error: missing DATA partition ${diskname}${prefix}4";
	   exit 1
	fi
	
	echo_green "Populating partitions done"
fi

if [ $eject ]; then 
	pretty_header "Eject SD card"
	yn=y
else
	pretty_header "Eject SD card?"
	read -p "Do you want to eject the SD card (y/n)? " yn # read user input
fi

if [ "$yn" != "${yn#[Yy]}" ]; then # checks if y or Y is selected
	
	umount ${diskname}${prefix}* # unmount all partitions
	udisksctl power-off -b ${diskname} # eject SD card
	
	echo_green "The SD card was successfully ejected" 
	
else
	echo_blue "The SD card is still mounted"
fi
