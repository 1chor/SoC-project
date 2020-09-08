# define number of parallel jobs
set JOBS 4

open_project soc_project.xpr

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
	
} else {
	puts "\n+++++++++++++++++++++++++++"
	puts "++ Synthesis up-to-date! ++"
	puts "+++++++++++++++++++++++++++\n"
}

# Set status
set STATUS [get_property STATUS [get_runs impl_1]]
set REFRESH [get_property NEEDS_REFRESH [get_runs synth_1]]

# Output status for debugging
#puts $STATUS
#puts $REFRESH

if {$STATUS == "route_design Complete!" && $REFRESH == 0} {
	puts "\n++++++++++++++++++++++++"
	puts "++ Generate bitstream ++"
	puts "++++++++++++++++++++++++\n"
	
	launch_runs impl_1 -to_step write_bitstream -jobs $JOBS
	wait_on_run impl_1
	
} elseif {$STATUS != "write_bitstream Complete!" || $REFRESH == 1} {
	puts "\n++++++++++++++++++++++++"
	puts "++ Run implementation ++"
	puts "++++++++++++++++++++++++\n"
	
	reset_run impl_1
	launch_runs impl_1 -jobs $JOBS
	wait_on_run impl_1
	
	puts "\n++++++++++++++++++++++++"
	puts "++ Generate bitstream ++"
	puts "++++++++++++++++++++++++\n"
	
	launch_runs impl_1 -to_step write_bitstream -jobs $JOBS
	wait_on_run impl_1
	
} else {
	puts "\n+++++++++++++++++++++++++++"
	puts "++ Bitstream up-to-date! ++"
	puts "+++++++++++++++++++++++++++\n"
}

close_project
