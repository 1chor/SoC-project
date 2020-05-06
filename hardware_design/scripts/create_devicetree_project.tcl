hsi open_hw_design "./soc_project.sdk/zcu102_wrapper.hdf"
hsi set_repo_path "../device-tree-xlnx"
set cpu_name [lindex [hsi get_cells -filter {IP_TYPE==PROCESSOR}] 0]
hsi create_sw_design device-tree -os device_tree -proc $cpu_name
hsi set_property CONFIG.periph_type_overrides "{BOARD zcu102-rev1.0}" [hsi get_os]
hsi generate_target -dir ./soc_project.sdk/device-tree
