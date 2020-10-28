#!/bin/sh

Filepath=/storage/emulated/0/SoC

while [ 1 ]; do
	sleep 10
	
	#Control for Filter
	if [ -f "$Filepath/filter.txt" ]; then
		echo "filter.txt exists." > /dev/kmsg
		
		rm $Filepath/filter.txt
	fi
	
	#Control for blake2b
	if [ -f "$Filepath/blake2b.txt" ]; then
		echo "blake2b.txt exists." > /dev/kmsg
		
		rm $Filepath/blake2b.txt
	fi
	
	#Control for partial reconfiguration
	if [ -f "$Filepath/partial.txt" ]; then
		echo "partial.txt exists." > /dev/kmsg
		
		rm $Filepath/partial.txt
	fi
	
	#Control for LEDs
	if [ -f "$Filepath/led.txt" ]; then
		echo "led.txt exists." > /dev/kmsg
		
		rm $Filepath/led.txt
	fi
		
done
