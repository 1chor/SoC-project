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

function depends () {
		echo_red "Xilinx $1 must be installed and in your PATH"
		echo_red "try: source /opt/Xilinx/Vivado/201x.x/settings64.sh"
		exit 1
}

########################################################################

if [ "$1" == "clean" ]; then
	pretty_header "Cleaning repository"
	
	#Linux Kernel
	cd mpsoc-linux-xlnx 
	make distclean
	cd ..
	
	#hdmi-modules
	cd hdmi-modules
	make clean
	cd ..
	
	#u-boot
	cd mpsoc-u-boot-xlnx
	make distclean
	cd ..
	
	#ARM Trusted Firmware"
	cd arm-trusted-firmware
	make distclean
	cd ..
	
	#clean-up bootimage
	cd bootimage
	find . \! -name '*.sh' -delete
	cd ..
	
	echo_green "Cleaning repository done"
	
	exit
fi

########################################################################

pretty_header "Fetching Submodules"

cd ..
git submodule update --init --recursive

echo_green "Fetching Submodules done"

########################################################################

pretty_header "Checking for required Xilinx tools"

command -v vivado >/dev/null 2>&1 || depends vivado
command -v xsdk >/dev/null 2>&1 || depends xsdk
command -v hsi >/dev/null 2>&1 || depends hsi
command -v bootgen >/dev/null 2>&1 || depends bootgen

vivado_ver=$(vivado -version |head -1 | cut -d' ' -f2 | cut -c2-)
if [ "$vivado_ver" != 2018.1 ]; then
	echo_red "Currently installed version: $vivado_ver"
	echo_red "Vivado version 2018.1 is needed."
	echo_red "Please make sure the correct version is installed." #check if it works with a newer version >= 2018.1 
	exit 1
fi

echo_green "Checking for required Xilinx tools done"

########################################################################

pretty_header "Building Linux Kernel"

#setup environment
export COMPILER=aarch64-linux-gnu-gcc
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

#load kernel config
cd mpsoc-linux-xlnx
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- xilinx_zynqmp_android_defconfig

#build
make -j4
cp arch/arm64/boot/Image ../bootimage/

cd ..

echo_green "Building Linux Kernel done"

########################################################################

pretty_header "Compiling kernel modules for PL devices"

for driver in ./drivers/*/
do
	cd $driver
	make
	cd ../..
done
cp ./drivers/*/*.ko bootimage/modules

#compiling hdmi modules
cd hdmi-modules
export KERNEL_SRC=../mpsoc-linux-xlnx
export SRC=.
make all
cp hdmi/xilinx-vphy.ko ../bootimage/modules
cp hdmi/xilinx-hdmi-tx.ko ../bootimage/modules
cp hdmi/xilinx-hdmi-rx.ko ../bootimage/modules
cp misc/dp159.ko ../bootimage/modules
cp clk/si5324.ko ../bootimage/modules
cd ..

echo_green "Compiling kernel modules for PL devices done"

########################################################################

pretty_header "Building u-boot"

cd mpsoc-u-boot-xlnx
make CROSS_COMPILE=aarch64-linux-gnu- xilinx_zynqmp_zcu102_rev1_0_defconfig
make CROSS_COMPILE=aarch64-linux-gnu-
cp u-boot.elf ../bootimage/u-boot.elf
cd ..

echo_green "Building u-boot done"

########################################################################

#pretty_header "Creating hardware design"

#scripts/build_project.tcl

#delete existing software design
rm -rf hardware_design/soc_project.sdk/ 

########################################################################

pretty_header "Generating Bitstreams"

cd hardware_design
make -f scripts/Makefile bit
cd ..

echo_green "Generating Bitstreams done"

########################################################################

pretty_header "Exporting hardware design"

cd hardware_design
vivado -nolog -nojournal -mode batch -source scripts/export_hw.tcl
cd ..

echo_green "Exporting hardware design done"

########################################################################

pretty_header "Building FSBL"

cd hardware_design
xsdk -batch -source ./scripts/create_fsbl_project.tcl
cd ..

echo_green "Building FSBL done"

########################################################################

pretty_header "Building PMUFW"

cd hardware_design
xsdk -batch -source ./scripts/create_pmufw_project.tcl
cd ..

echo_green "Building PMUFW done"

########################################################################

pretty_header "Compiling device tree"

#create device tree project
cd hardware_design
make -f scripts/Makefile dts

#compiling a device tree blob
make -f scripts/Makefile compile
cp soc_project.sdk/device-tree/system-top.dtb ../bootimage/zynqmp-zcu102-rev1.0.dtb
cd ..

echo_green "Compiling device tree done"

########################################################################

pretty_header "Building ARM Trusted Firmware"

cd arm-trusted-firmware
make PLAT=zynqmp bl31
cp build/zynqmp/release/bl31/bl31.elf ../bootimage/bl31.elf
cd ..

echo_green "Building ARM Trusted Firmware done"

########################################################################

if [ ! -f bootimage/zcu102.bif ]; then

	pretty_header "Creating zcu102.bif"

	cd bootimage
	echo "the_ROM_image:" > zcu102.bif
	echo "{" >> zcu102.bif
	echo -e "\t[destination_cpu=a53-0, bootloader] hardware_design/soc_project.sdk/fsbl/Release/fsbl.elf" >> zcu102.bif
	echo -e "\t[pmufw_image] hardware_design/soc_project.sdk/pmufw/Release/pmufw.elf" >> zcu102.bif
	echo -e "\t[destination_device = pl] hardware_design/soc_project.sdk/zcu102_wrapper.bit" >> zcu102.bif
	echo -e "\t[destination_cpu=a53-0, exception_level=el-3, trustzone] bootimage/bl31.elf" >> zcu102.bif
	echo -e "\t[destination_cpu = a53-0, exception_level=el-2] bootimage/u-boot.elf" >> zcu102.bif
	echo "}" >> zcu102.bif
	cd ..

	echo_green "Creating zcu102.bif done"
	
fi

########################################################################

pretty_header "Generating BOOT.BIN"
bootgen -arch zynqmp -image bootimage/zcu102.bif -w -o i bootimage/BOOT.BIN

echo_green "Generating BOOT.BIN done"
