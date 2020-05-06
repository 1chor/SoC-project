
proc init {cell_path otherInfo} {

    set num_layers [get_property CONFIG.NR_LAYERS [get_bd_cells $cell_path]]
    set layer1_type [get_property CONFIG.LAYER1_INTF_TYPE [get_bd_cells $cell_path]]
    set layer2_type [get_property CONFIG.LAYER2_INTF_TYPE [get_bd_cells $cell_path]]
    set layer3_type [get_property CONFIG.LAYER3_INTF_TYPE [get_bd_cells $cell_path]]
    set layer4_type [get_property CONFIG.LAYER4_INTF_TYPE [get_bd_cells $cell_path]]
    set layer5_type [get_property CONFIG.LAYER5_INTF_TYPE [get_bd_cells $cell_path]]
    set layer6_type [get_property CONFIG.LAYER6_INTF_TYPE [get_bd_cells $cell_path]]
    set layer7_type [get_property CONFIG.LAYER7_INTF_TYPE [get_bd_cells $cell_path]]
    set layer8_type [get_property CONFIG.LAYER8_INTF_TYPE [get_bd_cells $cell_path]]

    if { [expr $num_layers > 1] && [expr $layer1_type == 0] } {
        set_property CONFIG.HAS_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video1]
        set_property CONFIG.HAS_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video1]
        set_property CONFIG.SUPPORTS_NARROW_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video1]
        set_property CONFIG.SUPPORTS_NARROW_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video1]
    }
    if { [expr $num_layers > 2] && [expr $layer2_type == 0] } {
        set_property CONFIG.HAS_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video2]
        set_property CONFIG.HAS_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video2]
        set_property CONFIG.SUPPORTS_NARROW_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video2]
        set_property CONFIG.SUPPORTS_NARROW_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video2]
    }
    if { [expr $num_layers > 3] && [expr $layer3_type == 0] } {
        set_property CONFIG.HAS_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video3]
        set_property CONFIG.HAS_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video3]
        set_property CONFIG.SUPPORTS_NARROW_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video3]
        set_property CONFIG.SUPPORTS_NARROW_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video3]
    }
    if { [expr $num_layers > 4] && [expr $layer4_type == 0] } {
        set_property CONFIG.HAS_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video4]
        set_property CONFIG.HAS_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video4]
        set_property CONFIG.SUPPORTS_NARROW_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video4]
        set_property CONFIG.SUPPORTS_NARROW_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video4]
    }
    if { [expr $num_layers > 5] && [expr $layer5_type == 0] } {
        set_property CONFIG.HAS_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video5]
        set_property CONFIG.HAS_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video5]
        set_property CONFIG.SUPPORTS_NARROW_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video5]
        set_property CONFIG.SUPPORTS_NARROW_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video5]
    }
    if { [expr $num_layers > 6] && [expr $layer6_type == 0] } {
        set_property CONFIG.HAS_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video6]
        set_property CONFIG.HAS_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video6]
        set_property CONFIG.SUPPORTS_NARROW_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video6]
        set_property CONFIG.SUPPORTS_NARROW_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video6]
    }
    if { [expr $num_layers > 7] && [expr $layer7_type == 0] } {
        set_property CONFIG.HAS_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video7]
        set_property CONFIG.HAS_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video7]
        set_property CONFIG.SUPPORTS_NARROW_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video7]
        set_property CONFIG.SUPPORTS_NARROW_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video7]
    }
    if { [expr $num_layers > 8] && [expr $layer8_type == 0] } {
        set_property CONFIG.HAS_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video8]
        set_property CONFIG.HAS_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video8]
        set_property CONFIG.SUPPORTS_NARROW_BURST 0 [get_bd_intf_pins $cell_path/m_axi_mm_video8]
        set_property CONFIG.SUPPORTS_NARROW_BURST.VALUE_SRC CONSTANT [get_bd_intf_pins $cell_path/m_axi_mm_video8]
    }
}

proc post_config_ip {cell_path otherInfo} {

    set num_out [get_property CONFIG.AXIMM_NUM_OUTSTANDING [get_bd_cells $cell_path]]
    set bur_len [get_property CONFIG.AXIMM_BURST_LENGTH [get_bd_cells $cell_path]]

    set num_layers [get_property CONFIG.NR_LAYERS [get_bd_cells $cell_path]]
    set layer1_type [get_property CONFIG.LAYER1_INTF_TYPE [get_bd_cells $cell_path]]
    set layer2_type [get_property CONFIG.LAYER2_INTF_TYPE [get_bd_cells $cell_path]]
    set layer3_type [get_property CONFIG.LAYER3_INTF_TYPE [get_bd_cells $cell_path]]
    set layer4_type [get_property CONFIG.LAYER4_INTF_TYPE [get_bd_cells $cell_path]]
    set layer5_type [get_property CONFIG.LAYER5_INTF_TYPE [get_bd_cells $cell_path]]
    set layer6_type [get_property CONFIG.LAYER6_INTF_TYPE [get_bd_cells $cell_path]]
    set layer7_type [get_property CONFIG.LAYER7_INTF_TYPE [get_bd_cells $cell_path]]
    set layer8_type [get_property CONFIG.LAYER8_INTF_TYPE [get_bd_cells $cell_path]]

    if { [expr $num_layers > 1] && [expr $layer1_type == 0] } {
        set_property CONFIG.NUM_READ_OUTSTANDING $num_out [get_bd_intf_pins $cell_path/m_axi_mm_video1]
        set_property CONFIG.MAX_BURST_LENGTH $bur_len [get_bd_intf_pins $cell_path/m_axi_mm_video1]
    }
    if { [expr $num_layers > 2] && [expr $layer2_type == 0] } {
        set_property CONFIG.NUM_READ_OUTSTANDING $num_out [get_bd_intf_pins $cell_path/m_axi_mm_video2]
        set_property CONFIG.MAX_BURST_LENGTH $bur_len [get_bd_intf_pins $cell_path/m_axi_mm_video2]
    }
    if { [expr $num_layers > 3] && [expr $layer3_type == 0] } {
        set_property CONFIG.NUM_READ_OUTSTANDING $num_out [get_bd_intf_pins $cell_path/m_axi_mm_video3]
        set_property CONFIG.MAX_BURST_LENGTH $bur_len [get_bd_intf_pins $cell_path/m_axi_mm_video3]
    }
    if { [expr $num_layers > 4] && [expr $layer4_type == 0] } {
        set_property CONFIG.NUM_READ_OUTSTANDING $num_out [get_bd_intf_pins $cell_path/m_axi_mm_video4]
        set_property CONFIG.MAX_BURST_LENGTH $bur_len [get_bd_intf_pins $cell_path/m_axi_mm_video4]
    }
    if { [expr $num_layers > 5] && [expr $layer5_type == 0] } {
        set_property CONFIG.NUM_READ_OUTSTANDING $num_out [get_bd_intf_pins $cell_path/m_axi_mm_video5]
        set_property CONFIG.MAX_BURST_LENGTH $bur_len [get_bd_intf_pins $cell_path/m_axi_mm_video5]
    }
    if { [expr $num_layers > 6] && [expr $layer6_type == 0] } {
        set_property CONFIG.NUM_READ_OUTSTANDING $num_out [get_bd_intf_pins $cell_path/m_axi_mm_video6]
        set_property CONFIG.MAX_BURST_LENGTH $bur_len [get_bd_intf_pins $cell_path/m_axi_mm_video6]
    }
    if { [expr $num_layers > 7] && [expr $layer7_type == 0] } {
        set_property CONFIG.NUM_READ_OUTSTANDING $num_out [get_bd_intf_pins $cell_path/m_axi_mm_video7]
        set_property CONFIG.MAX_BURST_LENGTH $bur_len [get_bd_intf_pins $cell_path/m_axi_mm_video7]
    }
    if { [expr $num_layers > 8] && [expr $layer8_type == 0] } {
        set_property CONFIG.NUM_READ_OUTSTANDING $num_out [get_bd_intf_pins $cell_path/m_axi_mm_video8]
        set_property CONFIG.MAX_BURST_LENGTH $bur_len [get_bd_intf_pins $cell_path/m_axi_mm_video8]
    }
}
