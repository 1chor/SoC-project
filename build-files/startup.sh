#!/system/bin/sh

#logcat -b all -d

echo "+++++++++++++++++++++++++++++++"
echo "++                           ++"
echo "++ Start user startup script ++"
echo "++                           ++"
echo "+++++++++++++++++++++++++++++++"

echo "++ Loading vphy module ++"
insmod /data/modules/xilinx-vphy.ko

echo "++ Loading clock module ++"
insmod /data/modules/si5324.ko

echo "++ Loading HDMI I2c module ++"
insmod /data/modules/dp159.ko

echo "++ Loading HDMI TX module ++"
insmod /data/modules/xilinx-hdmi-tx.ko

echo "++ Loading HDMI RX module ++"
insmod /data/modules/xilinx-hdmi-rx.ko
