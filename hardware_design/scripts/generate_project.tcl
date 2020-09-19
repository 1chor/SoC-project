# define number of parallel jobs
set JOBS 4

open_project soc_project.xpr

puts "\n+++++++++++++++++++++++"
puts "++ Run OOC synthesis ++"
puts "+++++++++++++++++++++++\n"

puts "Running Syntax Check ..."
set cs [check_syntax -fileset [current_fileset] -return_string -quiet]
if {[regexp {^CRITICAL WARNING:.*$} $cs] == 1} {
	puts $cs
	puts "ERROR: Syntax Check failed for fileset [current_fileset]"
	exit 2
} else {
	puts "Syntax Check for fileset [current_fileset] passed"
}

foreach bd [get_files -quiet "*.bd"] {
	if {![get_property IS_GENERATED $bd]} {
		generate_target all $bd
		create_ip_run $bd
	}
}

set run_list [get_runs -quiet -filter "IS_SYNTHESIS == true && NAME != synth_1"]
if {[llength $run_list] != 0} {
	foreach run $run_list {
		reset_run $run
	}
	launch_runs $run_list -jobs $JOBS
	foreach run $run_list {
		wait_on_run $run
		if {[get_property PROGRESS $run] != "100%"} {
			puts "ERROR: OOC Synthesis of ${run} failed"
			exit 2
		}
	}
}
puts "INFO: Out-Of-Context Synthesis done"

#~ # Set status
#~ set STATUS [get_property STATUS [get_runs OOC_synth]]
#~ set REFRESH [get_property NEEDS_REFRESH [get_runs OOC_synth]]

#~ # Output status for debugging
#~ #puts $STATUS
#~ #puts $REFRESH

#~ if {$STATUS != "synth_design Complete!" || $REFRESH == 1} {
	
	#~ puts "\n+++++++++++++++++++++++"
	#~ puts "++ Run OOC synthesis ++"
	#~ puts "+++++++++++++++++++++++\n"
	
	#~ reset_run OOC_synth
	#~ launch_runs OOC_synth -jobs $JOBS
	#~ wait_on_run OOC_synth
	
#~ } else {
	#~ puts "\n+++++++++++++++++++++++++++++++"
	#~ puts "++ OOC Synthesis up-to-date! ++"
	#~ puts "+++++++++++++++++++++++++++++++\n"
#~ }

# Set status
set STATUS [get_property STATUS [get_runs synth_1]]
set REFRESH [get_property NEEDS_REFRESH [get_runs synth_1]]

# Output status for debugging
#puts $STATUS
#puts $REFRESH

if {$STATUS != "synth_design Complete!" || $REFRESH == 1} {
	
	puts "\n+++++++++++++++++++"
	puts "++ Run synthesis ++"
	puts "+++++++++++++++++++\n"
	
	reset_run synth_1
	launch_runs synth_1 -jobs $JOBS
	wait_on_run synth_1
	if {[get_property PROGRESS synth_1] != "100%"} {
		puts "ERROR: Synthesis failed"
		exit 2
	}
	puts "INFO: Synthesis done"
	
} else {
	puts "\n+++++++++++++++++++++++++++"
	puts "++ Synthesis up-to-date! ++"
	puts "+++++++++++++++++++++++++++\n"
}

# Set status
set STATUS [get_property STATUS [get_runs impl_1]]
set STATUS_c0 [get_property STATUS [get_runs child_0_impl_1]]
set STATUS_c1 [get_property STATUS [get_runs child_1_impl_1]]

set REFRESH [get_property NEEDS_REFRESH [get_runs impl_1]]
set REFRESH_c0 [get_property NEEDS_REFRESH [get_runs child_0_impl_1]]
set REFRESH_c1 [get_property NEEDS_REFRESH [get_runs child_1_impl_1]]

# Set run_list
set run_list [get_runs -filter "IS_IMPLEMENTATION == true && CONSTRSET == constrs_1"]

# Output status for debugging
#puts $STATUS
#puts $STATUS_c0
#puts $STATUS_c1
#puts $REFRESH
#puts $REFRESH_c0
#puts $REFRESH_c1

if {$STATUS == "route_design Complete!" && $STATUS_c0 == "route_design Complete!" && $STATUS_c1 == "route_design Complete!" && $REFRESH == 0 && $REFRESH_c0 == 0 && $REFRESH_c1 == 0} {
	puts "\n++++++++++++++++++++++++"
	puts "++ Generate bitstream ++"
	puts "++++++++++++++++++++++++\n"
	
	launch_runs $run_list -to_step write_bitstream -jobs $JOBS
	
	foreach run $run_list {
		wait_on_run $run
		if {[get_property PROGRESS $run ] != "100%"} {
			puts "ERROR: Generating bitstream of ${run} failed"
			exit 2
		}
	}
	puts "INFO: Generating bitstream done"
	
} elseif {$STATUS != "write_bitstream Complete!" || $STATUS_c0 != "write_bitstream Complete!" || $STATUS_c1 != "write_bitstream Complete!" || $REFRESH == 1 || $REFRESH_c0 == 1 || $REFRESH_c1 == 1} {
	puts "\n++++++++++++++++++++++++"
	puts "++ Run implementation ++"
	puts "++++++++++++++++++++++++\n"
	
	foreach run $run_list {
		reset_run $run
	}
	
	launch_runs $run_list -jobs $JOBS
	
	foreach run $run_list {
		wait_on_run $run
		if {[get_property PROGRESS $run ] != "100%"} {
			puts "ERROR: Implementation of ${run} failed"
			exit 2
		}
	}
	puts "INFO: Implementation done"
	
	# check if PR modules are compatible
	pr_verify -initial ./soc_project.runs/impl_1/zcu102_wrapper_routed.dcp -additional {./soc_project.runs/child_0_impl_1/zcu102_wrapper_routed.dcp ./soc_project.runs/child_1_impl_1/zcu102_wrapper_routed.dcp}
	
	puts "\n++++++++++++++++++++++++"
	puts "++ Generate bitstream ++"
	puts "++++++++++++++++++++++++\n"
		
	launch_runs $run_list -to_step write_bitstream -jobs $JOBS
	
	foreach run $run_list {
		wait_on_run $run
		if {[get_property PROGRESS $run ] != "100%"} {
			puts "ERROR: Generating bitstream of ${run} failed"
			exit 2
		}
	}
	puts "INFO: Generating bitstream done"
	
} else {
	puts "\n+++++++++++++++++++++++++++"
	puts "++ Bitstream up-to-date! ++"
	puts "+++++++++++++++++++++++++++\n"
}

close_project
