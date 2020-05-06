hsi open_hw_design "./soc_project.sdk/zcu102_wrapper.hdf"
set cpu_name [lindex [hsi get_cells -filter {IP_TYPE==PROCESSOR}] 0]
sdk setws ./soc_project.sdk
sdk createhw -name hw_0 -hwspec "./soc_project.sdk/zcu102_wrapper.hdf"
sdk createapp -name fsbl -hwproject hw_0 -proc $cpu_name -os standalone -lang C -app {Zynq MP FSBL}
configapp -app fsbl build-config release
sdk projects -build -type all
