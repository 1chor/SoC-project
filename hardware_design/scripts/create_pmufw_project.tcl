hsi open_hw_design "./soc_project.sdk/zcu102_wrapper.hdf"
set cpu_name [lindex [hsi get_cells -filter {IP_TYPE==PROCESSOR}] 6]
sdk setws ./soc_project.sdk
openhw "./soc_project.sdk/zcu102_wrapper.hdf"
sdk createapp -name pmufw -hwproject hw_0 -proc $cpu_name -os standalone -lang C -app {ZynqMP PMU Firmware}
configapp -app pmufw build-config release
sdk projects -build -type all
