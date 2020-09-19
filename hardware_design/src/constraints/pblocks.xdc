create_pblock pblock_filter_pr1
add_cells_to_pblock [get_pblocks pblock_filter_pr1] [get_cells -quiet [list simple_filter_0/USER_LOGIC_I/filter_logic_0]]
resize_pblock [get_pblocks pblock_filter_pr1] -add {SLICE_X29Y330:SLICE_X34Y359}
resize_pblock [get_pblocks pblock_filter_pr1] -add {DSP48E2_X6Y132:DSP48E2_X6Y143}
resize_pblock [get_pblocks pblock_filter_pr1] -add {RAMB18_X4Y132:RAMB18_X4Y143}
resize_pblock [get_pblocks pblock_filter_pr1] -add {RAMB36_X4Y66:RAMB36_X4Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_filter_pr1]
set_property CONTAIN_ROUTING 1 [get_pblocks pblock_filter_pr1]
set_property EXCLUDE_PLACEMENT 1 [get_pblocks pblock_filter_pr1]