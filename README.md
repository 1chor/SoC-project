# SoC project

## Introduction
 The purpose of this project is to implement a partial reconfigurable IoT device, which can exchane parts of the synthesized hardware during runtime for a suitable application. 
 Android 8 is set up to run on the software processing unit of the Zynq UltraScale+ MPSoC ZCU102 Evaluation Kit.
 An application is presented that applies filters to given images. 
 These filters may be subject to updates in the future and the app is able to download such updates and apply them to the programmable logic using dynamic partial reconfiguration.
 
 This project is an extansion and improvement of the [Dynamic Partial Reconfiguration on an IoT device](https://github.com/FlorianMuttenthaler/SocLabPartialReconfigIot) project based on the Digilent ZedBoard.
 
 Android 8 for Xilinx Zynq UltraScale+ MPSoC is provided by [Mentor Embedded](https://www.mentor.com/embedded-software/semiconductors/xilinx/ultrascale) [Getting Started with Android 8 v2018.1 for Xilinx Zynq UltraScale MPSoC](https://github.com/MentorEmbedded/mpsoc-manifest/wiki/Getting-Started-with-Android-8-v2018.1-for-Xilinx-Zynq-UltraScale--MPSoC). 
 
## Initializing Build Environment

### Installing JDK
  Please check [AOSP: Installing the JDK](https://source.android.com/setup/build/initializing#installing-the-jdk) and [AOSP: JDK Requirements](https://source.android.com/setup/build/requirements#latest-version) for the detailed instructions to install proper version of the JDK. Please use **OpenJDK 8** to build **Android 8**. On Ubuntu 18.04 it can be installed with:

  `$ sudo apt-get install openjdk-8-jdk`

### Installing packages
  Please follow [AOSP: Installing Required Packages](https://source.android.com/setup/build/initializing#installing-required-packages-ubuntu-1404) to initialize build environment depending on your build host. Please note that builds are tested with 64-bit Ubuntu LTS 18.04.4 hosts. For the Ubuntu LTS 148.04.4 the following packages are required:

```shell
  $ sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip
```
  In addition to the packages from the AOSP guide, please install the following for the SD card initialization scripts:

  `$ sudo apt-get install dosfstools e2fsprogs parted`

## Project structure
 The project is structured as follows:
 
 ```
 .
 ├── hardware_design		# contains the hardware design
 ├── petalinux			# contains linux files
 ├── android			# contains android files
 ├── u-boot			# contains u-boot files
 ├── drivers			# contains drivers for custom hardware components
 ├── bootimage			# contains built files
 ├── prebuilt			# contains prebuilt files ready to use
 ├── server			# contains file server   
 ├── client			# contains andoid app
 └── report			# contains project report
 ```
 
## Project progress

 - [ ] Make Linux bootable
 - [ ] Enable HDMI output 
 - [ ] Add custom hardware
 - [ ] Enable dynamic partial reconfiguration
 - [ ] Make Android bootable
 
## Preparing SD Card
 Run the following script to prepare bootable SD card. 
 Use path to your SD card instead of `/dev/mmcblk0`. 
 Use zcu102 as a second argument to specify which product subfolder in `out/target/product/` to use.

 ```shell
 $ cd WORKING_DIRECTORY
 $ sudo device/xilinx/common/scripts/mksdcard.sh /dev/mmcblk0 zcu102 es2
 ```
 
 :warning: The paths need to be adapted :warning:
 
## Running the Build on the Xilinx ZCU102
 - Set boot mode of the board to "SD Boot". Insert SD card to the board.
 - Connect external monitor using HDMI. Please note that HDMI must be connected before board power-on.
 - Connect USB mouse (and optionally USB keyboard) as shown below.
 - Power on the board
 <p align="center">
 <img src="./report/images/ZCU102.png" width="600">
 </p>