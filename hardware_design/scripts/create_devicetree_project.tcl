proc build_dts {} {
	hsi open_hw_design "./soc_project.sdk/zcu102_wrapper.hdf"
	hsi set_repo_path "../device-tree-xlnx"
	set cpu_name [lindex [hsi get_cells -filter {IP_TYPE==PROCESSOR}] 0]
	hsi create_sw_design device-tree -os device_tree -proc $cpu_name
	hsi set_property CONFIG.periph_type_overrides "{BOARD zcu102-rev1.0}" [hsi get_os]
	hsi generate_target -dir ./soc_project.sdk/device-tree
	hsi close_hw_design [hsi current_hw_design]
}

proc include_dtsi {dtsi_file} {
	if {[file exists $dtsi_file]} {
		file copy -force $dtsi_file ./soc_project.sdk/device-tree 
		set fp [open ./soc_project.sdk/device-tree/system-top.dts r]
		set file_data [read $fp]
		close $fp
		set fileId [open ./soc_project.sdk/device-tree/system-top.dts "w"]
		set data [split $file_data "\n"]
		foreach line $data {
			puts $fileId $line
		}
		puts $fileId "#include \"$dtsi_file\""
		close $fileId
	}
}
