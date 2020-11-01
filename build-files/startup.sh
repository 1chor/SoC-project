#!/system/bin/sh

echo > /dev/kmsg # empty line

echo "+++++++++++++++++++++++++++++++" > /dev/kmsg
echo "++                           ++" > /dev/kmsg
echo "++ Start user startup script ++" > /dev/kmsg
echo "++                           ++" > /dev/kmsg
echo "+++++++++++++++++++++++++++++++" > /dev/kmsg

echo > /dev/kmsg # empty line

echo "++ Configure adb for ethernet ++" > /dev/kmsg
stop adbd
setprop service.adp.tcp.port 5555
start adbd

echo > /dev/kmsg # empty line

-echo "++ List IP address ++" > /dev/kmsg
echo "IPv4 address: " > /dev/kmsg
ifconfig eth0 | grep 'inet addr' | cut -d: -f2 | cut -d" " -f1 > /dev/kmsg

echo > /dev/kmsg # empty line

echo "++ Loading myled module ++" > /dev/kmsg
insmod /data/modules/myled.ko

echo > /dev/kmsg # empty line

echo "++ Loading blake2b module ++" > /dev/kmsg
insmod /data/modules/blake2b.ko

echo > /dev/kmsg # empty line

echo "++ Loading simple_filters module ++" > /dev/kmsg
insmod /data/modules/simple_filters.ko

echo > /dev/kmsg # empty line

#remount filesystem rw
mount -o remount,rw /

echo "++ Starting Root client script ++" > /dev/kmsg
sh /data/Root_Client.sh &

echo "+++++++++++++++++++++++++++++++" > /dev/kmsg
echo "++                           ++" > /dev/kmsg
echo "++ End user startup script ++" > /dev/kmsg
echo "++                           ++" > /dev/kmsg
echo "+++++++++++++++++++++++++++++++" > /dev/kmsg

echo > /dev/kmsg # empty line
