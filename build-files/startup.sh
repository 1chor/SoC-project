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

echo "++ Loading vphy module ++" > /dev/kmsg
insmod /data/modules/xilinx-vphy.ko

echo > /dev/kmsg # empty line

echo "++ Loading clock module ++" > /dev/kmsg
insmod /data/modules/si5324.ko

echo > /dev/kmsg # empty line

echo "++ Loading HDMI I2c module ++" > /dev/kmsg
insmod /data/modules/dp159.ko

echo > /dev/kmsg # empty line

echo "++ Loading HDMI TX module ++" > /dev/kmsg
insmod /data/modules/xilinx-hdmi-tx.ko

echo > /dev/kmsg # empty line

echo "++ Loading HDMI RX module ++" > /dev/kmsg
insmod /data/modules/xilinx-hdmi-rx.ko

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

mount -o remount,rw /

echo "+++++++++++++++++++++++++++++++" > /dev/kmsg
echo "++                           ++" > /dev/kmsg
echo "++ End user startup script ++" > /dev/kmsg
echo "++                           ++" > /dev/kmsg
echo "+++++++++++++++++++++++++++++++" > /dev/kmsg

echo > /dev/kmsg # empty line
