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
make -j4
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
cp u-boot.elf ../bootimage/u-boot.elf
cd ..

########################################################################

#pretty_header "Building FSBL"

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

########################################################################

pretty_header "Building ARM Trusted Firmware"

cd arm-trusted-firmware
make PLAT=zynqmp bl31
cp build/zynqmp/release/bl31/bl31.elf ../bootimage/bl31.elf
cd ..

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

########################################################################

#pretty_header "Generating BOOT.BIN"
bootgen -arch zynqmp -image bootimage/zcu102.bif -w -o i bootimage/BOOT.BIN
