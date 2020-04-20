# SoC project

## Introduction
 The purpose of this project is to implement a partial reconfigurable IoT device, which can exchane parts of the synthesized hardware during runtime for a suitable application. 
 Android 8 is set up to run on the software processing unit of the Zynq UltraScale+ MPSoC ZCU102 Evaluation Kit.
 An application is presented that applies filters to given images. 
 These filters may be subject to updates in the future and the app is able to download such updates and apply them to the programmable logic using dynamic partial reconfiguration.
 
 This project is an extansion and improvement of the [Dynamic Partial Reconfiguration on an IoT device](https://github.com/FlorianMuttenthaler/SocLabPartialReconfigIot) project based on the Digilent ZedBoard.
 
 Android 8 for Xilinx Zynq UltraScale+ MPSoC is provided by Mentor Embedded [Getting Started with Android 8 v2018.1 for Xilinx Zynq UltraScale MPSoC](https://github.com/MentorEmbedded/mpsoc-manifest/wiki/Getting-Started-with-Android-8-v2018.1-for-Xilinx-Zynq-UltraScale--MPSoC). 
 
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
 - Connect USB mouse (and optionally USB keyboard) as shown below:
 ![ZCU102 setup](report/images/ZCU102.png | width=500)
 - Power on the board

