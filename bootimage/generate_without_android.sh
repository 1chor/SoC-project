function pretty_header() {
		msg="# $* #"
		edge=$(echo "$msg" | sed 's/./#/g')
		echo "$edge"
		echo "$msg"
		echo "$edge"
}

pretty_header "Fetching Submodules"

cd ..
git submodule update --init --recursive

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
make -j
cp arch/arm64/boot/Image ../bootimage/ #rename necessary?? "kernel"

cd ..

########################################################################

#pretty_header "Compiling kernel modules for PL devices"

#for driver in ./drivers/*/
#do
#	cd $driver
#	make
#	cd ../..
#done
#cp ./drivers/*/*.ko bootimage

########################################################################

#pretty_header "Generating Netlists"

########################################################################

#pretty_header "Generating Bitstreams"

########################################################################

pretty_header "Building u-boot"

cd mpsoc-u-boot-xlnx
make CROSS_COMPILE=aarch64-linux-gnu- xilinx_zynqmp_zcu102_rev1_0_defconfig
make CROSS_COMPILE=aarch64-linux-gnu-
#cp u-boot ../bootimage/u-boot.elf
cd ..

########################################################################

#pretty_header "Building FSBL"

########################################################################

#pretty_header "Compiling device tree"
#xilinx tool xsct

########################################################################

pretty_header "Building ARM Trusted Firmware"

make PLAT=zynqmp RESET_TO_BL31=1
#cp

########################################################################

#pretty_header "Generating BOOT.BIN"
