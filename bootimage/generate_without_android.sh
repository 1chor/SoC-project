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
if [ "$vivado_ver" != v2018.1 ] ; then
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
cp arch/arm64/boot/Image ../bootimage/ #rename necessary?? "kernel"

cd ..

echo_green "Building Linux Kernel done"

########################################################################

#pretty_header "Compiling kernel modules for PL devices"

#for driver in ./drivers/*/
#do
#	cd $driver
#	make
#	cd ../..
#done
#cp ./drivers/*/*.ko bootimage

#echo_green "Compiling kernel modules for PL devices done"

########################################################################

#pretty_header "Generating Netlists"

#echo_green "Generating Netlists done"

########################################################################

#pretty_header "Generating Bitstreams"

#echo_green "Generating Bitstreams done"

########################################################################

pretty_header "Building u-boot"

cd mpsoc-u-boot-xlnx
make CROSS_COMPILE=aarch64-linux-gnu- xilinx_zynqmp_zcu102_rev1_0_defconfig
make CROSS_COMPILE=aarch64-linux-gnu-
cp u-boot.elf ../bootimage/u-boot.elf
cd ..

echo_green "Building u-boot done"

########################################################################

#pretty_header "Building FSBL"

#echo_green "Building FSBL done"

########################################################################

#pretty_header "Compiling device tree"
cd hardware_design/vivado/soc_project.sdk/device_tree
#start SDK?

#pre-processing device tree sources
gcc -I . -E -nostdinc -undef -D_DTS__ -x assembler-with-cpp -o system.dts system-top.dts

#compiling a device tree blob
cd ../../../../mpsoc-linux-xlnx
./scripts/dtc/dtc -I dts -O dtb -o ../bootimage/devicetree.dtb ../hardware_design/vivado/soc_project.sdk/device_tree/system.dts
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

#pretty_header "Creating zcu102.bif"

cd bootimage
echo "the_ROM_image:" > zcu102.bif
echo "{" >> zcu102.bif
echo -e "\t[destination_cpu=a53-0, bootloader] /media/soc/Volume/SoC-project/hardware_design/vivado/soc_project.sdk/FSBL/Debug/FSBL.elf" >> zcu102.bif
echo -e "\t[pmufw_image] /media/soc/Volume/SoC-project/hardware_design/vivado/soc_project.sdk/pmufw/Debug/pmufw.elf" >> zcu102.bif
echo -e "\t[destination_device = pl] /media/soc/Volume/SoC-project/hardware_design/vivado/soc_project.sdk/zcu102_wrapper.bit" >> zcu102.bif
echo -e "\t[destination_cpu=a53-0, exception_level=el-3, trustzone] /media/soc/Volume/SoC-project/bootimage/bl31.elf" >> zcu102.bif
echo -e "\t[destination_cpu = a53-0, exception_level=el-2] /media/soc/Volume/SoC-project/bootimage/u-boot.elf" >> zcu102.bif
echo "}" >> zcu102.bif
cd ..

echo_green "Creating zcu102.bif done"

########################################################################

#pretty_header "Generating BOOT.BIN"
bootgen -arch zynqmp -image bootimage/zcu102.bif -w -o i bootimage/BOOT.BIN

echo_green "Generating BOOT.BIN done"
