# SoC project

## Introduction
 The purpose of this project is to implement a partial reconfigurable IoT device, which can exchane parts of the synthesized hardware during runtime for a suitable application. 
 Android 8 is set up to run on the software processing unit of the Zynq UltraScale+ MPSoC ZCU102 Evaluation Kit.
 An application is presented that applies filters to given images. These filters may be subject to updates in the future and the app is able to download such updates and apply them to the programmable logic using dynamic partial reconfiguration.
 
 This project is an extansion and improvement of the [Dynamic Partial Reconfiguration on an IoT device](https://github.com/FlorianMuttenthaler/SocLabPartialReconfigIot) project based on the Digilent ZedBoard.
 
## Project structure
 The project is structured as follows:
 
 - hardware_design		# contains the hardware design
 - petalinux			# contains linux files
 - android				# contains android files
 - u-boot				# contains u-boot files
 - drivers				# contains drivers for custom hardware components
 - bootimage 			# contains built files
 - prebuilt				# contains prebuilt files ready to use
 - server				# contains file server
 - client				# contains andoid app
 - report				# contains project report
 
## Project progress
