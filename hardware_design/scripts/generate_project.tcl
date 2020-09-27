# define number of parallel jobs
set JOBS 4

[catch {current_project} project]

if {$project != "soc_project" } {
	open_project soc_project.xpr
} else {
	puts "INFO: Project is already open"
	set CLOSE false
}

puts "\n++++++++++++++++++++++"
puts "++ Run Syntax Check ++"
puts "++++++++++++++++++++++\n"

set cs [check_syntax -fileset [current_fileset] -return_string -quiet]
if {[regexp {^CRITICAL WARNING:.*$} $cs] == 1} {
	puts $cs
	puts "ERROR: Syntax Check failed for fileset [current_fileset]"
	exit 2
} else {
	puts "INFO: Syntax Check for fileset [current_fileset] passed"
}

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
	
	reset_run [get_runs synth_1]
	launch_runs [get_runs synth_1] -jobs $JOBS
	wait_on_run [get_runs synth_1]
	if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
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
	
	puts "\n+++++++++++++++++++++++++"
	puts "++ Check timing report ++"
	puts "+++++++++++++++++++++++++\n"
	
	foreach run $run_list {
		set TNS  [get_property STATS.TNS  $run]
		set THS  [get_property STATS.THS  $run]
		set TPWS [get_property STATS.TPWS $run]
		
		if {[expr {$TNS != 0}] || [expr {$THS != 0}] || [expr {$TPWS != 0}]} {
			puts "TIMING of implementation ${run} failed:"
			puts "\tTNS = ${TNS}"
			puts "\tTHS = ${THS}"
			puts "\tTPWS = ${TPWS}"
		} else {
			puts "TIMING of implementation ${run} is OK"
		}
	}
	
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

if {$CLOSE == false} { 
	puts "INFO: Project is still open"
} else {
	close_project
}
