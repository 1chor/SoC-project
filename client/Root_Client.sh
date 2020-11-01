#!/bin/sh

package_name=com.lab.soc.client
activity=MainActivity
APK_file=/data/SoC_Client.apk
Filepath=/storage/emulated/0/SoC
emptyhash="00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"

# check if app is already installed
is_installed=`pm list packages $package_name`
if test -n "$is_installed"; then
	echo "app is already installed"
else
	echo "install app"
	pm install $APK_file
fi

# make work dir if not exists
if [ ! -d $Filepath ]; then
	mkdir -p $Filepath
fi

cd $Filepath
rm *
echo > filtered.bin

# start app
am start -n $package_name/$activity

while [ 1 ]; do
	sleep 10
		
	# control for filter
	if [ -f "$Filepath/filter.txt" ]; then
		echo "filter.txt exists." > /dev/kmsg
		
		rm $Filepath/fBitmap.bin
		
		# echo bitmap to filter kernel module
		echo "$( < filter.txt )" > /proc/simple_filters
		
		# wait for filter to complete
		sleep 0.05
		
		# rename filtered bitmap for app
		cp filtered.bin fBitmap.bin 
		
		rm "$( < filter.txt )"
		rm $Filepath/filter.txt
		
		echo "filter operation done." > /dev/kmsg
	fi
		
	# control for blake2b
	if [ -f "$Filepath/blake2b.txt" ]; then
		echo "blake2b.txt exists." > /dev/kmsg
		rm $Filepath/hash.txt
		rm $Filepath/tmp.txt
		
		# cat bitstream to null device, otherwise the kernel module will fail 
		cat "$( < blake2b.txt )" > /dev/null
		
		# echo bitstream to blake2b kernel module
		echo "$( < blake2b.txt )" > /proc/blake2b
		
		# wait for hash to complete
		sleep 0.1
		
		# read blake2b kernel module
		cat /proc/blake2b > $Filepath/tmp.txt
		
		# check if hash is written
		isInFile=$(cat tmp.txt | grep -c "$emptyhash")

		while [ $isInFile -ne 0 ]; do
			# wait for hash to complete
			sleep 0.05
			
			# read blake2b kernel module
			cat /proc/blake2b > $Filepath/tmp.txt
		
			# check if hash is written
			isInFile=$(cat tmp.txt | grep -c "$emptyhash")
		done
			
		cp tmp.txt hash.txt 
		
		rm $Filepath/blake2b.txt
		
		echo "blake2b operation done." > /dev/kmsg
	fi
	
	# control for partial reconfiguration
	if [ -f "$Filepath/partial.txt" ]; then
		echo "partial.txt exists." > /dev/kmsg
		
		# set variables
		bitpath="$( < partial.txt )"
		echo $bitpath > /dev/null
		bit=${bitpath##*/}
		echo $bit > /dev/null
		
		# set flags for partial bitstream
		echo 1 > /sys/class/fpga_manager/fpga0/flags
		
		# load partial bitstream
		cp $bitpath /lib/firmware
		echo $bit > /sys/class/fpga_manager/fpga0/firmware
		
		# control LEDs dependent on the filter reconfigured
		if [ $bit = "blue_filter.bin" ]; then 
			echo 0x03 > /proc/myled
		elif [ $bit = "green_filter.bin" ]; then 
			echo 0x18 > /proc/myled
		elif [ $bit = "red_filter.bin" ]; then 
			echo 0C0 > /proc/myled
		else
			echo 0x00 > /proc/myled
		fi
		 
		rm $Filepath/partial.txt
		
		echo "partial operation done." > /dev/kmsg
	fi		
done
