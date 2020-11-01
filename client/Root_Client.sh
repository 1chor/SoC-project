#!/bin/sh

Filepath=/storage/emulated/0/SoC

if [ ! -d $Filepath ]; then
	mkdir -p $Filepath
fi

cd $Filepath
rm *
echo > filtered.bin

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
	fi
		
	# control for blake2b
	if [ -f "$Filepath/blake2b.txt" ]; then
		echo "blake2b.txt exists." > /dev/kmsg
		rm $Filepath/hash.txt
		
		# cat bitstream to null device, otherwise the kernel module will fail 
		cat "$( < blake2b.txt )" > /dev/null
		
		# echo bitstream to blake2b kernel module
		echo "$( < blake2b.txt )" > /proc/blake2b
		
		# wait for hash to complete
		sleep 0.1
		
		# read blake2b kernel module
		cat /proc/blake2b > $Filepath/hash.txt
		
		rm $Filepath/blake2b.txt
	fi
	
	# control for partial reconfiguration
	if [ -f "$Filepath/partial.txt" ]; then
		echo "partial.txt exists." > /dev/kmsg
		
		# set flags for partial bitstream
		echo 1 > /sys/class/fpga_manager/fpga0/flags
		
		# load partial bitstream
		cp "$( < partial.txt )" /lib/firmware
		echo "$( < partial.txt )" /sys/class/fpga_manager/fpga0/firmware
		
		# control LEDs dependent on the filter reconfigured
		if [ "$( < partial.txt )" = "blue_filter.bin" ]; then 
			echo 0x03 > /proc/myled
		elif [ "$( < partial.txt )" = "green_filter.bin" ]; then 
			echo 0x18 > /proc/myled
		elif [ "$( < partial.txt )" = "red_filter.bin" ]; then 
			echo 0C0 > /proc/myled
		else
			echo 0x00 > /proc/myled
		fi
		 
		rm $Filepath/partial.txt
	fi		
done
