proc init_gui { IPINST } {
    #Adding Page
    set Page_0  [  ipgui::add_page $IPINST -name "Page 0" -display_name {Page 0}]
    set_property tooltip {Page 0} ${Page_0}

    set Component_Name  [  ipgui::add_param $IPINST -name "Component_Name" -parent ${Page_0} -display_name {Component Name}]
    set_property tooltip {Component Name} ${Component_Name}

    set VIDEO_FORMAT [ipgui::add_param $IPINST -parent ${Page_0} -name "VIDEO_FORMAT" -display_name {Streaming Video Format} -widget comboBox]
    
    set SAMPLES_PER_CLOCK  [  ipgui::add_param $IPINST -name "SAMPLES_PER_CLOCK" -parent ${Page_0} -display_name {Samples per Clock} -widget comboBox]
    set_property tooltip {Samples per Clock} ${SAMPLES_PER_CLOCK}

    set MAX_DATA_WIDTH  [  ipgui::add_param $IPINST -name "MAX_DATA_WIDTH" -parent ${Page_0} -display_name {Maximum Data Width} -widget comboBox]
    set_property tooltip {Maximum Data Width} ${MAX_DATA_WIDTH}

    set NR_LAYERS  [  ipgui::add_param $IPINST -name "NR_LAYERS" -parent ${Page_0} -display_name {Number of Overlay Layers}]
    set_property tooltip {Number of Layers} ${NR_LAYERS}

    set MAX_COLS  [  ipgui::add_param $IPINST -name "MAX_COLS" -parent ${Page_0} -display_name {Maximum Number of Columns}]
    set_property tooltip {Maximum Number of Columns} ${MAX_COLS}

    set MAX_ROWS  [  ipgui::add_param $IPINST -name "MAX_ROWS" -parent ${Page_0} -display_name {Maximum Number of Rows}]
    set_property tooltip {Maximum Number of Rows} ${MAX_ROWS}

    set AXIMM_ADDR_WIDTH [ipgui::add_param $IPINST -name "AXIMM_ADDR_WIDTH" -parent ${Page_0} -widget comboBox]
    set_property tooltip {Specifies the number of address bits on the memory mapped AXI4 interface} ${AXIMM_ADDR_WIDTH}

    variable table
    set table [ipgui::add_table $IPINST  -name "Layer Table" -rows "9" -columns "6" -parent ${Page_0}]

    ipgui::add_static_text  $IPINST -name Layer -parent $table -text "Layer ID" -center_align true
    ipgui::add_static_text  $IPINST -name VideoFormat -parent $table -text "Video\nFormat" -center_align true
    ipgui::add_static_text  $IPINST -name AlphaEnable -parent $table -text "Enable\nGlobal Alpha" -center_align true
    ipgui::add_static_text  $IPINST -name UpsampleEnable -parent $table -text "Enable\nScaling" -center_align true
    ipgui::add_static_text  $IPINST -name Width -parent $table -text "Line Buffer\nWidth" -center_align true
    ipgui::add_static_text  $IPINST -name Type -parent $table -text "Interface\nType" -center_align true

    set_property cell_location "0,0" [ipgui::get_textspec Layer -of $IPINST]        
    set_property cell_location "0,1" [ipgui::get_textspec VideoFormat -of $IPINST]
    set_property cell_location "0,2" [ipgui::get_textspec AlphaEnable -of $IPINST]
    set_property cell_location "0,3" [ipgui::get_textspec UpsampleEnable -of $IPINST]
    set_property cell_location "0,4" [ipgui::get_textspec Width -of $IPINST]
    set_property cell_location "0,5" [ipgui::get_textspec Type -of $IPINST]

    # Layer 1
    ipgui::add_static_text  $IPINST -name Layer1 -parent  $table -text "1" -center_align true
    set_property cell_location "1,0" [ipgui::get_textspec Layer1 -of $IPINST] 

    set LAYER1_VIDEO_FORMAT [ipgui::add_param $IPINST -parent $table -name LAYER1_VIDEO_FORMAT]
    set_property cell_location "1,1" [ipgui::get_guiparamspec LAYER1_VIDEO_FORMAT -of $IPINST]
        
    set LAYER1_ALPHA [ipgui::add_param $IPINST -parent $table -name LAYER1_ALPHA -show_range false]
    set_property cell_location "1,2" [ipgui::get_guiparamspec LAYER1_ALPHA -of $IPINST]

    set LAYER1_UPSAMPLE [ipgui::add_param $IPINST -parent $table -name LAYER1_UPSAMPLE -show_range false]
    set_property cell_location "1,3" [ipgui::get_guiparamspec LAYER1_UPSAMPLE -of $IPINST]
    
    set LAYER1_MAX_WIDTH [ipgui::add_param $IPINST -parent $table -name LAYER1_MAX_WIDTH -show_range false]
    set_property cell_location "1,4" [ipgui::get_guiparamspec LAYER1_MAX_WIDTH -of $IPINST]

    set LAYER1_INTF_TYPE [ipgui::add_param $IPINST -parent $table -name LAYER1_INTF_TYPE]
    set_property cell_location "1,5" [ipgui::get_guiparamspec LAYER1_INTF_TYPE -of $IPINST]
    
    set_property tooltip  "Set the line buffer width of layer 1. Valid range is ([get_property range $LAYER1_MAX_WIDTH])." $LAYER1_MAX_WIDTH
    set_property tooltip  "Enable alpha blending for layer 1." $LAYER1_ALPHA
    set_property tooltip  "Enable scaling for layer 1." $LAYER1_UPSAMPLE

    # Layer 2
    ipgui::add_static_text  $IPINST -name Layer2 -parent  $table -text "2" -center_align true
    set_property cell_location "2,0" [ipgui::get_textspec Layer2 -of $IPINST] 
        
    set LAYER2_VIDEO_FORMAT [ipgui::add_param $IPINST -parent $table -name LAYER2_VIDEO_FORMAT]
    set_property cell_location "2,1" [ipgui::get_guiparamspec LAYER2_VIDEO_FORMAT -of $IPINST]
        
    set LAYER2_ALPHA [ipgui::add_param $IPINST -parent $table -name LAYER2_ALPHA -show_range false]
    set_property cell_location "2,2" [ipgui::get_guiparamspec LAYER2_ALPHA -of $IPINST]

    set LAYER2_UPSAMPLE [ipgui::add_param $IPINST -parent $table -name LAYER2_UPSAMPLE -show_range false]
    set_property cell_location "2,3" [ipgui::get_guiparamspec LAYER2_UPSAMPLE -of $IPINST]
    
    set LAYER2_MAX_WIDTH [ipgui::add_param $IPINST -parent $table -name LAYER2_MAX_WIDTH -show_range false]
    set_property cell_location "2,4" [ipgui::get_guiparamspec LAYER2_MAX_WIDTH -of $IPINST]

    set LAYER2_INTF_TYPE [ipgui::add_param $IPINST -parent $table -name LAYER2_INTF_TYPE]
    set_property cell_location "2,5" [ipgui::get_guiparamspec LAYER2_INTF_TYPE -of $IPINST]
    
    set_property tooltip  "Set the line buffer width of layer 2. Valid range is ([get_property range $LAYER2_MAX_WIDTH])." $LAYER2_MAX_WIDTH
    set_property tooltip  "Enable alpha blending for layer 2." $LAYER2_ALPHA
    set_property tooltip  "Enable scaling for layer 2." $LAYER2_UPSAMPLE

    # Layer 3
    ipgui::add_static_text  $IPINST -name Layer3 -parent  $table -text "3" -center_align true
    set_property cell_location "3,0" [ipgui::get_textspec Layer3 -of $IPINST] 
        
    set LAYER3_VIDEO_FORMAT [ipgui::add_param $IPINST -parent $table -name LAYER3_VIDEO_FORMAT]
    set_property cell_location "3,1" [ipgui::get_guiparamspec LAYER3_VIDEO_FORMAT -of $IPINST]
        
    set LAYER3_ALPHA [ipgui::add_param $IPINST -parent $table -name LAYER3_ALPHA -show_range false]
    set_property cell_location "3,2" [ipgui::get_guiparamspec LAYER3_ALPHA -of $IPINST]

    set LAYER3_UPSAMPLE [ipgui::add_param $IPINST -parent $table -name LAYER3_UPSAMPLE -show_range false]
    set_property cell_location "3,3" [ipgui::get_guiparamspec LAYER3_UPSAMPLE -of $IPINST]
    
    set LAYER3_MAX_WIDTH [ipgui::add_param $IPINST -parent $table -name LAYER3_MAX_WIDTH -show_range false]
    set_property cell_location "3,4" [ipgui::get_guiparamspec LAYER3_MAX_WIDTH -of $IPINST]

    set LAYER3_INTF_TYPE [ipgui::add_param $IPINST -parent $table -name LAYER3_INTF_TYPE]
    set_property cell_location "3,5" [ipgui::get_guiparamspec LAYER3_INTF_TYPE -of $IPINST]
    
    set_property tooltip  "Set the line buffer width of layer 3. Valid range is ([get_property range $LAYER3_MAX_WIDTH])." $LAYER3_MAX_WIDTH
    set_property tooltip  "Enable alpha blending for layer 3." $LAYER3_ALPHA
    set_property tooltip  "Enable scaling for layer 3." $LAYER3_UPSAMPLE

    # Layer 4
    ipgui::add_static_text  $IPINST -name Layer4 -parent  $table -text "4" -center_align true
    set_property cell_location "4,0" [ipgui::get_textspec Layer4 -of $IPINST] 
        
    set LAYER4_VIDEO_FORMAT [ipgui::add_param $IPINST -parent $table -name LAYER4_VIDEO_FORMAT]
    set_property cell_location "4,1" [ipgui::get_guiparamspec LAYER4_VIDEO_FORMAT -of $IPINST]
        
    set LAYER4_ALPHA [ipgui::add_param $IPINST -parent $table -name LAYER4_ALPHA -show_range false]
    set_property cell_location "4,2" [ipgui::get_guiparamspec LAYER4_ALPHA -of $IPINST]

    set LAYER4_UPSAMPLE [ipgui::add_param $IPINST -parent $table -name LAYER4_UPSAMPLE -show_range false]
    set_property cell_location "4,3" [ipgui::get_guiparamspec LAYER4_UPSAMPLE -of $IPINST]
    
    set LAYER4_MAX_WIDTH [ipgui::add_param $IPINST -parent $table -name LAYER4_MAX_WIDTH -show_range false]
    set_property cell_location "4,4" [ipgui::get_guiparamspec LAYER4_MAX_WIDTH -of $IPINST]

    set LAYER4_INTF_TYPE [ipgui::add_param $IPINST -parent $table -name LAYER4_INTF_TYPE]
    set_property cell_location "4,5" [ipgui::get_guiparamspec LAYER4_INTF_TYPE -of $IPINST]
    
    set_property tooltip  "Set the line buffer width of layer 4. Valid range is ([get_property range $LAYER4_MAX_WIDTH])." $LAYER4_MAX_WIDTH
    set_property tooltip  "Enable alpha blending for layer 4." $LAYER4_ALPHA
    set_property tooltip  "Enable scaling for layer 4." $LAYER4_UPSAMPLE

    # Layer 5
    ipgui::add_static_text  $IPINST -name Layer5 -parent  $table -text "5" -center_align true
    set_property cell_location "5,0" [ipgui::get_textspec Layer5 -of $IPINST] 
        
    set LAYER5_VIDEO_FORMAT [ipgui::add_param $IPINST -parent $table -name LAYER5_VIDEO_FORMAT]
    set_property cell_location "5,1" [ipgui::get_guiparamspec LAYER5_VIDEO_FORMAT -of $IPINST]
        
    set LAYER5_ALPHA [ipgui::add_param $IPINST -parent $table -name LAYER5_ALPHA -show_range false]
    set_property cell_location "5,2" [ipgui::get_guiparamspec LAYER5_ALPHA -of $IPINST]

    set LAYER5_UPSAMPLE [ipgui::add_param $IPINST -parent $table -name LAYER5_UPSAMPLE -show_range false]
    set_property cell_location "5,3" [ipgui::get_guiparamspec LAYER5_UPSAMPLE -of $IPINST]
    
    set LAYER5_MAX_WIDTH [ipgui::add_param $IPINST -parent $table -name LAYER5_MAX_WIDTH -show_range false]
    set_property cell_location "5,4" [ipgui::get_guiparamspec LAYER5_MAX_WIDTH -of $IPINST]

    set LAYER5_INTF_TYPE [ipgui::add_param $IPINST -parent $table -name LAYER5_INTF_TYPE]
    set_property cell_location "5,5" [ipgui::get_guiparamspec LAYER5_INTF_TYPE -of $IPINST]
    
    set_property tooltip  "Set the line buffer width of layer 5. Valid range is ([get_property range $LAYER5_MAX_WIDTH])." $LAYER5_MAX_WIDTH
    set_property tooltip  "Enable alpha blending for layer 5." $LAYER5_ALPHA
    set_property tooltip  "Enable scaling for layer 5." $LAYER5_UPSAMPLE

    # Layer 6
    ipgui::add_static_text  $IPINST -name Layer6 -parent  $table -text "6" -center_align true
    set_property cell_location "6,0" [ipgui::get_textspec Layer6 -of $IPINST] 
        
    set LAYER6_VIDEO_FORMAT [ipgui::add_param $IPINST -parent $table -name LAYER6_VIDEO_FORMAT]
    set_property cell_location "6,1" [ipgui::get_guiparamspec LAYER6_VIDEO_FORMAT -of $IPINST]
        
    set LAYER6_ALPHA [ipgui::add_param $IPINST -parent $table -name LAYER6_ALPHA -show_range false]
    set_property cell_location "6,2" [ipgui::get_guiparamspec LAYER6_ALPHA -of $IPINST]

    set LAYER6_UPSAMPLE [ipgui::add_param $IPINST -parent $table -name LAYER6_UPSAMPLE -show_range false]
    set_property cell_location "6,3" [ipgui::get_guiparamspec LAYER6_UPSAMPLE -of $IPINST]
    
    set LAYER6_MAX_WIDTH [ipgui::add_param $IPINST -parent $table -name LAYER6_MAX_WIDTH -show_range false]
    set_property cell_location "6,4" [ipgui::get_guiparamspec LAYER6_MAX_WIDTH -of $IPINST]

    set LAYER6_INTF_TYPE [ipgui::add_param $IPINST -parent $table -name LAYER6_INTF_TYPE]
    set_property cell_location "6,5" [ipgui::get_guiparamspec LAYER6_INTF_TYPE -of $IPINST]
    
    set_property tooltip  "Set the line buffer width of layer 6. Valid range is ([get_property range $LAYER6_MAX_WIDTH])." $LAYER6_MAX_WIDTH
    set_property tooltip  "Enable alpha blending for layer 6." $LAYER6_ALPHA
    set_property tooltip  "Enable scaling for layer 6." $LAYER6_UPSAMPLE

    # Layer 7
    ipgui::add_static_text  $IPINST -name Layer7 -parent  $table -text "7" -center_align true
    set_property cell_location "7,0" [ipgui::get_textspec Layer7 -of $IPINST] 
        
    set LAYER7_VIDEO_FORMAT [ipgui::add_param $IPINST -parent $table -name LAYER7_VIDEO_FORMAT]
    set_property cell_location "7,1" [ipgui::get_guiparamspec LAYER7_VIDEO_FORMAT -of $IPINST]
        
    set LAYER7_ALPHA [ipgui::add_param $IPINST -parent $table -name LAYER7_ALPHA -show_range false]
    set_property cell_location "7,2" [ipgui::get_guiparamspec LAYER7_ALPHA -of $IPINST]

    set LAYER7_UPSAMPLE [ipgui::add_param $IPINST -parent $table -name LAYER7_UPSAMPLE -show_range false]
    set_property cell_location "7,3" [ipgui::get_guiparamspec LAYER7_UPSAMPLE -of $IPINST]
    
    set LAYER7_MAX_WIDTH [ipgui::add_param $IPINST -parent $table -name LAYER7_MAX_WIDTH -show_range false]
    set_property cell_location "7,4" [ipgui::get_guiparamspec LAYER7_MAX_WIDTH -of $IPINST]

    set LAYER7_INTF_TYPE [ipgui::add_param $IPINST -parent $table -name LAYER7_INTF_TYPE]
    set_property cell_location "7,5" [ipgui::get_guiparamspec LAYER7_INTF_TYPE -of $IPINST]
    
    set_property tooltip  "Set the line buffer width of layer 7. Valid range is ([get_property range $LAYER7_MAX_WIDTH])." $LAYER7_MAX_WIDTH
    set_property tooltip  "Enable alpha blending for layer 7." $LAYER7_ALPHA
    set_property tooltip  "Enable scaling for layer 7." $LAYER7_UPSAMPLE

    # Layer 8
    ipgui::add_static_text  $IPINST -name Layer8 -parent  $table -text "8" -center_align true
    set_property cell_location "8,0" [ipgui::get_textspec Layer8 -of $IPINST] 
        
    set LAYER8_VIDEO_FORMAT [ipgui::add_param $IPINST -parent $table -name LAYER8_VIDEO_FORMAT]
    set_property cell_location "8,1" [ipgui::get_guiparamspec LAYER8_VIDEO_FORMAT -of $IPINST]
        
    set LAYER8_ALPHA [ipgui::add_param $IPINST -parent $table -name LAYER8_ALPHA -show_range false]
    set_property cell_location "8,2" [ipgui::get_guiparamspec LAYER8_ALPHA -of $IPINST]

    set LAYER8_UPSAMPLE [ipgui::add_param $IPINST -parent $table -name LAYER8_UPSAMPLE -show_range false]
    set_property cell_location "8,3" [ipgui::get_guiparamspec LAYER8_UPSAMPLE -of $IPINST]
    
    set LAYER8_MAX_WIDTH [ipgui::add_param $IPINST -parent $table -name LAYER8_MAX_WIDTH -show_range false]
    set_property cell_location "8,4" [ipgui::get_guiparamspec LAYER8_MAX_WIDTH -of $IPINST]

    set LAYER8_INTF_TYPE [ipgui::add_param $IPINST -parent $table -name LAYER8_INTF_TYPE]
    set_property cell_location "8,5" [ipgui::get_guiparamspec LAYER8_INTF_TYPE -of $IPINST]
    
    set_property tooltip  "Set the line buffer width of layer 8. Valid range is ([get_property range $LAYER8_MAX_WIDTH])." $LAYER8_MAX_WIDTH
    set_property tooltip  "Enable alpha blending for layer 8." $LAYER8_ALPHA
    set_property tooltip  "Enable scaling for layer 8." $LAYER8_UPSAMPLE

	# Logo Layer
    set LOGO_LAYER  [  ipgui::add_param $IPINST -name "LOGO_LAYER" -parent ${Page_0} -display_name {Enable Logo Layer}]
    set_property tooltip {Enable Logo Layer} ${LOGO_LAYER}

    set LOGO_CTRL [ipgui::add_group $IPINST -parent  ${Page_0} -name "LOGO_CTRL" -layout vertical] 
    set_property display_name "Logo Control" [ipgui::get_groupspec LOGO_CTRL -of $IPINST]

    set MAX_LOGO_COLS  [  ipgui::add_param $IPINST -name "MAX_LOGO_COLS" -parent $LOGO_CTRL -display_name {Maximum Number of Columns for Logo}]
    set_property tooltip {Maximum Number of Columns for Logo} ${MAX_LOGO_COLS}

    set MAX_LOGO_ROWS  [  ipgui::add_param $IPINST -name "MAX_LOGO_ROWS" -parent $LOGO_CTRL -display_name {Maximum Number of Rows for Logo}]
    set_property tooltip {Maximum Number of Rows for Logo} ${MAX_LOGO_ROWS}

    set LOGO_TRANSPARENCY_COLOR  [  ipgui::add_param $IPINST -name "LOGO_TRANSPARENCY_COLOR" -parent $LOGO_CTRL -display_name {Enable Logo Transparency Color}]
    set_property tooltip {Enable Logo Transparency Color} ${LOGO_TRANSPARENCY_COLOR}

    set LOGO_PIXEL_ALPHA  [  ipgui::add_param $IPINST -name "LOGO_PIXEL_ALPHA" -parent $LOGO_CTRL -display_name {Enable Logo per Pixel Alpha}]
    set_property tooltip {Enable Logo per Pixel Alpha} ${LOGO_PIXEL_ALPHA}

    set C_USE_URAM [ipgui::add_param $IPINST -name "USE_URAM" -parent ${Page_0} -widget checkBox ]
    set uram_count [get_device_data D_URAM_COUNT []]
    if {$uram_count == 0} {
        set_property visible false $C_USE_URAM
    }
}

proc update_PARAM_VALUE.SAMPLES_PER_CLOCK { PARAM_VALUE.SAMPLES_PER_CLOCK } {
    # Procedure called to update SAMPLES_PER_CLOCK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SAMPLES_PER_CLOCK { PARAM_VALUE.SAMPLES_PER_CLOCK } {
    # Procedure called to validate SAMPLES_PER_CLOCK
    return true
}

proc update_PARAM_VALUE.MAX_DATA_WIDTH { PARAM_VALUE.MAX_DATA_WIDTH } {
    # Procedure called to update MAX_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_DATA_WIDTH { PARAM_VALUE.MAX_DATA_WIDTH } {
    # Procedure called to validate MAX_DATA_WIDTH
    return true
}

proc update_PARAM_VALUE.NR_LAYERS { PARAM_VALUE.NR_LAYERS } {
    # Procedure called to update NR_LAYERS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NR_LAYERS { PARAM_VALUE.NR_LAYERS } {
    # Procedure called to validate NR_LAYERS
    return true
}

proc update_PARAM_VALUE.AXIMM_DATA_WIDTH { PARAM_VALUE.SAMPLES_PER_CLOCK PARAM_VALUE.AXIMM_DATA_WIDTH } {
    # Procedure called to update AXIMM_DATA_WIDTH when any of the dependent parameters in the arguments change
    set samples_per_clock_value [get_property value ${PARAM_VALUE.SAMPLES_PER_CLOCK}]
    set aximm_data_width_value [ expr $samples_per_clock_value*64 ]
    set_property value $aximm_data_width_value ${PARAM_VALUE.AXIMM_DATA_WIDTH}
}

proc validate_PARAM_VALUE.AXIMM_DATA_WIDTH { PARAM_VALUE.AXIMM_DATA_WIDTH } {
    # Procedure called to validate AXIMM_DATA_WIDTH
    return true
}

proc update_PARAM_VALUE.AXIMM_NUM_OUTSTANDING { PARAM_VALUE.AXIMM_NUM_OUTSTANDING } {
    # Procedure called to update AXIMM_NUM_OUTSTANDING when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXIMM_NUM_OUTSTANDING { PARAM_VALUE.AXIMM_NUM_OUTSTANDING } {
    # Procedure called to validate AXIMM_NUM_OUTSTANDING
    return true
}

proc update_PARAM_VALUE.AXIMM_BURST_LENGTH { PARAM_VALUE.AXIMM_BURST_LENGTH } {
    # Procedure called to update AXIMM_BURST_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXIMM_BURST_LENGTH { PARAM_VALUE.AXIMM_BURST_LENGTH } {
    # Procedure called to validate AXIMM_BURST_LENGTH
    return true
}

proc update_PARAM_VALUE.AXIMM_ADDR_WIDTH { PARAM_VALUE.AXIMM_ADDR_WIDTH PARAM_VALUE.NR_LAYERS PARAM_VALUE.LAYER1_INTF_TYPE PARAM_VALUE.LAYER2_INTF_TYPE PARAM_VALUE.LAYER3_INTF_TYPE PARAM_VALUE.LAYER4_INTF_TYPE PARAM_VALUE.LAYER5_INTF_TYPE PARAM_VALUE.LAYER6_INTF_TYPE PARAM_VALUE.LAYER7_INTF_TYPE PARAM_VALUE.LAYER8_INTF_TYPE IPINST} {
    # Procedure called to update AXIMM_ADDR_WIDTH when any of the dependent parameters in the arguments change
    set num_layers [get_property value ${PARAM_VALUE.NR_LAYERS}]
    set layer1_intf [get_property value ${PARAM_VALUE.LAYER1_INTF_TYPE}]
    set layer2_intf [get_property value ${PARAM_VALUE.LAYER2_INTF_TYPE}]
    set layer3_intf [get_property value ${PARAM_VALUE.LAYER3_INTF_TYPE}]
    set layer4_intf [get_property value ${PARAM_VALUE.LAYER4_INTF_TYPE}]
    set layer5_intf [get_property value ${PARAM_VALUE.LAYER5_INTF_TYPE}]
    set layer6_intf [get_property value ${PARAM_VALUE.LAYER6_INTF_TYPE}]
    set layer7_intf [get_property value ${PARAM_VALUE.LAYER7_INTF_TYPE}]
    set layer8_intf [get_property value ${PARAM_VALUE.LAYER8_INTF_TYPE}]
}

proc validate_PARAM_VALUE.AXIMM_ADDR_WIDTH { PARAM_VALUE.AXIMM_ADDR_WIDTH } {
    # Procedure called to validate AXIMM_ADDR_WIDTH
    return true
}


proc update_PARAM_VALUE.LOGO_LAYER { PARAM_VALUE.LOGO_LAYER PARAM_VALUE.NR_LAYERS IPINST} {
    set num_layers [get_property value ${PARAM_VALUE.NR_LAYERS} ] 
    
    if {$num_layers > 1} {
        set_property enabled true ${PARAM_VALUE.LOGO_LAYER}
    } else {
        set_property value true ${PARAM_VALUE.LOGO_LAYER}
        set_property enabled false ${PARAM_VALUE.LOGO_LAYER}
    }
}

proc validate_PARAM_VALUE.LOGO_LAYER { PARAM_VALUE.LOGO_LAYER } {
    # Procedure called to validate LOGO_LAYER
    return true
}

proc update_PARAM_VALUE.MAX_LOGO_COLS { PARAM_VALUE.MAX_LOGO_COLS } {
    # Procedure called to update MAX_LOGO_COLS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_LOGO_COLS { PARAM_VALUE.MAX_LOGO_COLS } {
    # Procedure called to validate MAX_LOGO_COLS
    return true
}

proc update_PARAM_VALUE.MAX_COLS { PARAM_VALUE.MAX_COLS } {
    # Procedure called to update MAX_COLS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_COLS { PARAM_VALUE.MAX_COLS } {
    # Procedure called to validate MAX_COLS
    return true
}

proc update_gui_for_PARAM_VALUE.NR_LAYERS {PARAM_VALUE.LOGO_LAYER PARAM_VALUE.NR_LAYERS IPINST} {
    set num_layers [get_property value ${PARAM_VALUE.NR_LAYERS} ] 

    set list {1 2 3 4 5 6 7 8}
    set table [ipgui::get_tablespec -of $IPINST "Layer Table"]
    #set_property hidden_rows "" $table
    set index [tcl::lsearch $list [exp $num_layers - 1]]
    set list [tcl::lreplace $list 0 $index]
    set list [regsub -all " " $list ","]
    set_property hidden_rows "$list" $table
    
    if {$num_layers > 1} {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER1_ALPHA"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER1_ALPHA"]
    }
    if {$num_layers > 2} {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER2_ALPHA"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER2_ALPHA"]
    }
    if {$num_layers > 3} {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER3_ALPHA"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER3_ALPHA"]
    }
    if {$num_layers > 4} {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER4_ALPHA"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER4_ALPHA"]
    }
    if {$num_layers > 5} {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER5_ALPHA"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER5_ALPHA"]
    }
    if {$num_layers > 6} {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER6_ALPHA"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER6_ALPHA"]
    }
    if {$num_layers > 7} {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER7_ALPHA"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER7_ALPHA"]
    }
    if {$num_layers > 8} {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER8_ALPHA"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER8_ALPHA"]
    }
}

proc update_gui_for_PARAM_VALUE.LOGO_LAYER {PARAM_VALUE.LOGO_LAYER IPINST} {
    set logo [get_property value ${PARAM_VALUE.LOGO_LAYER} ] 
    if {$logo} {
        set_property visible true [ipgui::get_groupspec LOGO_CTRL -of $IPINST]
    } else {
        set_property visible false [ipgui::get_groupspec LOGO_CTRL -of $IPINST]
    }
}

proc update_gui_for_PARAM_VALUE.LAYER1_UPSAMPLE {PARAM_VALUE.LAYER1_UPSAMPLE IPINST} {
    set table [ipgui::get_tablespec -of $IPINST "Layer Table"]
    set upsample [get_property value ${PARAM_VALUE.LAYER1_UPSAMPLE} ] 

    if ($upsample) {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER1_MAX_WIDTH"]
        set_property enabled true [ipgui::get_guiparamspec -of $IPINST "LAYER1_MAX_WIDTH"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER1_MAX_WIDTH"]
        set_property enabled false [ipgui::get_guiparamspec -of $IPINST "LAYER1_MAX_WIDTH"]
    }   
}

proc update_gui_for_PARAM_VALUE.LAYER2_UPSAMPLE {PARAM_VALUE.LAYER2_UPSAMPLE IPINST} {
    set table [ipgui::get_tablespec -of $IPINST "Layer Table"]
    set upsample [get_property value ${PARAM_VALUE.LAYER2_UPSAMPLE} ] 

    if ($upsample) {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER2_MAX_WIDTH"]
        set_property enabled true [ipgui::get_guiparamspec -of $IPINST "LAYER2_MAX_WIDTH"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER2_MAX_WIDTH"]
        set_property enabled false [ipgui::get_guiparamspec -of $IPINST "LAYER2_MAX_WIDTH"]
    }   
}

proc update_gui_for_PARAM_VALUE.LAYER3_UPSAMPLE {PARAM_VALUE.LAYER3_UPSAMPLE IPINST} {
    set table [ipgui::get_tablespec -of $IPINST "Layer Table"]
    set upsample [get_property value ${PARAM_VALUE.LAYER3_UPSAMPLE} ] 

    if ($upsample) {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER3_MAX_WIDTH"]
        set_property enabled true [ipgui::get_guiparamspec -of $IPINST "LAYER3_MAX_WIDTH"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER3_MAX_WIDTH"]
        set_property enabled false [ipgui::get_guiparamspec -of $IPINST "LAYER3_MAX_WIDTH"]
    }   
}

proc update_gui_for_PARAM_VALUE.LAYER4_UPSAMPLE {PARAM_VALUE.LAYER4_UPSAMPLE IPINST} {
    set table [ipgui::get_tablespec -of $IPINST "Layer Table"]
    set upsample [get_property value ${PARAM_VALUE.LAYER4_UPSAMPLE} ] 

    if ($upsample) {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER4_MAX_WIDTH"]
        set_property enabled true [ipgui::get_guiparamspec -of $IPINST "LAYER4_MAX_WIDTH"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER4_MAX_WIDTH"]
        set_property enabled false [ipgui::get_guiparamspec -of $IPINST "LAYER4_MAX_WIDTH"]
    }   
}

proc update_gui_for_PARAM_VALUE.LAYER5_UPSAMPLE {PARAM_VALUE.LAYER5_UPSAMPLE IPINST} {
    set table [ipgui::get_tablespec -of $IPINST "Layer Table"]
    set upsample [get_property value ${PARAM_VALUE.LAYER5_UPSAMPLE} ] 

    if ($upsample) {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER5_MAX_WIDTH"]
        set_property enabled true [ipgui::get_guiparamspec -of $IPINST "LAYER5_MAX_WIDTH"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER5_MAX_WIDTH"]
        set_property enabled false [ipgui::get_guiparamspec -of $IPINST "LAYER5_MAX_WIDTH"]
    }   
}

proc update_gui_for_PARAM_VALUE.LAYER6_UPSAMPLE {PARAM_VALUE.LAYER6_UPSAMPLE IPINST} {
    set table [ipgui::get_tablespec -of $IPINST "Layer Table"]
    set upsample [get_property value ${PARAM_VALUE.LAYER6_UPSAMPLE} ] 

    if ($upsample) {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER6_MAX_WIDTH"]
        set_property enabled true [ipgui::get_guiparamspec -of $IPINST "LAYER6_MAX_WIDTH"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER6_MAX_WIDTH"]
        set_property enabled false [ipgui::get_guiparamspec -of $IPINST "LAYER6_MAX_WIDTH"]
    }   
}

proc update_gui_for_PARAM_VALUE.LAYER7_UPSAMPLE {PARAM_VALUE.LAYER7_UPSAMPLE IPINST} {
    set table [ipgui::get_tablespec -of $IPINST "Layer Table"]
    set upsample [get_property value ${PARAM_VALUE.LAYER7_UPSAMPLE} ] 

    if ($upsample) {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER7_MAX_WIDTH"]
        set_property enabled true [ipgui::get_guiparamspec -of $IPINST "LAYER7_MAX_WIDTH"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER7_MAX_WIDTH"]
        set_property enabled false [ipgui::get_guiparamspec -of $IPINST "LAYER7_MAX_WIDTH"]
    }   
}

proc update_gui_for_PARAM_VALUE.LAYER8_UPSAMPLE {PARAM_VALUE.LAYER8_UPSAMPLE IPINST} {
    set table [ipgui::get_tablespec -of $IPINST "Layer Table"]
    set upsample [get_property value ${PARAM_VALUE.LAYER8_UPSAMPLE} ] 

    if ($upsample) {
        set_property visible true [ipgui::get_guiparamspec -of $IPINST "LAYER8_MAX_WIDTH"]
        set_property enabled true [ipgui::get_guiparamspec -of $IPINST "LAYER8_MAX_WIDTH"]
    } else {
        set_property visible false [ipgui::get_guiparamspec -of $IPINST "LAYER8_MAX_WIDTH"]
        set_property enabled false [ipgui::get_guiparamspec -of $IPINST "LAYER8_MAX_WIDTH"]
    }   
}


proc update_PARAM_VALUE.LAYER1_VIDEO_FORMAT {PARAM_VALUE.LAYER1_INTF_TYPE PARAM_VALUE.LAYER1_VIDEO_FORMAT PARAM_VALUE.MAX_DATA_WIDTH IPINST} {
    set intf_type [get_property value ${PARAM_VALUE.LAYER1_INTF_TYPE} ]
    set bpc [get_property value ${PARAM_VALUE.MAX_DATA_WIDTH} ]
    if {$intf_type == 0} {
      if {$bpc > 8} {
        set_property range "10,27,11,12,28,13,26,14,15,16,17,18,19,20,29,21,22,23,24,25" ${PARAM_VALUE.LAYER1_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 14 {YUVA8} 15 {RGBX10} 16 {YUVX10} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 22 {Y_UV10} 23 {Y_UV10 420} 24 {Y8} 25 {Y10} 26 {BGRA8}] ,] ${PARAM_VALUE.LAYER1_VIDEO_FORMAT}
      } else {
        set_property range "10,27,11,12,28,13,26,14,17,18,19,20,29,21,24" ${PARAM_VALUE.LAYER1_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 26 {BGRA8} 14 {YUVA8} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 24 {Y8} ] ,] ${PARAM_VALUE.LAYER1_VIDEO_FORMAT}
      }
    } else {
      set_property range "0,1,2,3,5,6" ${PARAM_VALUE.LAYER1_VIDEO_FORMAT}
      set_property range_labels [join [dict create 0 {RGB} 1 {YUV 4:4:4} 2 {YUV 4:2:2} 3 {YUV 4:2:0} 5 {RGBA} 6 { YUVA 4:4:4}] ,] ${PARAM_VALUE.LAYER1_VIDEO_FORMAT}
    }
}

proc update_PARAM_VALUE.LAYER2_VIDEO_FORMAT {PARAM_VALUE.LAYER2_INTF_TYPE PARAM_VALUE.LAYER2_VIDEO_FORMAT PARAM_VALUE.MAX_DATA_WIDTH IPINST} {
    set intf_type [get_property value ${PARAM_VALUE.LAYER2_INTF_TYPE} ]
    set bpc [get_property value ${PARAM_VALUE.MAX_DATA_WIDTH} ]
    if {$intf_type == 0} {
      if {$bpc > 8} {
        set_property range "10,27,11,12,28,13,26,14,15,16,17,18,19,20,29,21,22,23,24,25" ${PARAM_VALUE.LAYER2_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 14 {YUVA8} 15 {RGBX10} 16 {YUVX10} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 22 {Y_UV10} 23 {Y_UV10 420} 24 {Y8} 25 {Y10} 26 {BGRA8}] ,] ${PARAM_VALUE.LAYER2_VIDEO_FORMAT}
      } else {
        set_property range "10,27,11,12,28,13,26,14,17,18,19,20,29,21,24" ${PARAM_VALUE.LAYER2_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 26 {BGRA8} 14 {YUVA8} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 24 {Y8} ] ,] ${PARAM_VALUE.LAYER2_VIDEO_FORMAT}
      }
    } else {
      set_property range "0,1,2,3,5,6" ${PARAM_VALUE.LAYER2_VIDEO_FORMAT}
      set_property range_labels [join [dict create 0 {RGB} 1 {YUV 4:4:4} 2 {YUV 4:2:2} 3 {YUV 4:2:0} 5 {RGBA} 6 { YUVA 4:4:4}] ,] ${PARAM_VALUE.LAYER2_VIDEO_FORMAT}
    }
}

proc update_PARAM_VALUE.LAYER3_VIDEO_FORMAT {PARAM_VALUE.LAYER3_INTF_TYPE PARAM_VALUE.LAYER3_VIDEO_FORMAT PARAM_VALUE.MAX_DATA_WIDTH IPINST} {
    set intf_type [get_property value ${PARAM_VALUE.LAYER3_INTF_TYPE} ]
    set bpc [get_property value ${PARAM_VALUE.MAX_DATA_WIDTH} ]
    if {$intf_type == 0} {
      if {$bpc > 8} {
        set_property range "10,27,11,12,28,13,26,14,15,16,17,18,19,20,29,21,22,23,24,25" ${PARAM_VALUE.LAYER3_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 14 {YUVA8} 15 {RGBX10} 16 {YUVX10} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 22 {Y_UV10} 23 {Y_UV10 420} 24 {Y8} 25 {Y10} 26 {BGRA8}] ,] ${PARAM_VALUE.LAYER3_VIDEO_FORMAT}
      } else {
        set_property range "10,27,11,12,28,13,26,14,17,18,19,20,29,21,24" ${PARAM_VALUE.LAYER3_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 26 {BGRA8} 14 {YUVA8} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 24 {Y8} ] ,] ${PARAM_VALUE.LAYER3_VIDEO_FORMAT}
      }
    } else {
      set_property range "0,1,2,3,5,6" ${PARAM_VALUE.LAYER3_VIDEO_FORMAT}
      set_property range_labels [join [dict create 0 {RGB} 1 {YUV 4:4:4} 2 {YUV 4:2:2} 3 {YUV 4:2:0} 5 {RGBA} 6 { YUVA 4:4:4}] ,] ${PARAM_VALUE.LAYER3_VIDEO_FORMAT}
    }
}

proc update_PARAM_VALUE.LAYER4_VIDEO_FORMAT {PARAM_VALUE.LAYER4_INTF_TYPE PARAM_VALUE.LAYER4_VIDEO_FORMAT PARAM_VALUE.MAX_DATA_WIDTH IPINST} {
    set intf_type [get_property value ${PARAM_VALUE.LAYER4_INTF_TYPE} ]
    set bpc [get_property value ${PARAM_VALUE.MAX_DATA_WIDTH} ]
    if {$intf_type == 0} {
      if {$bpc > 8} {
        set_property range "10,27,11,12,28,13,26,14,15,16,17,18,19,20,29,21,22,23,24,25" ${PARAM_VALUE.LAYER4_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 14 {YUVA8} 15 {RGBX10} 16 {YUVX10} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 22 {Y_UV10} 23 {Y_UV10 420} 24 {Y8} 25 {Y10} 26 {BGRA8}] ,] ${PARAM_VALUE.LAYER4_VIDEO_FORMAT}
      } else {
        set_property range "10,27,11,12,28,13,26,14,17,18,19,20,29,21,24" ${PARAM_VALUE.LAYER4_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 26 {BGRA8} 14 {YUVA8} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 24 {Y8} ] ,] ${PARAM_VALUE.LAYER4_VIDEO_FORMAT}
      }
    } else {
      set_property range "0,1,2,3,5,6" ${PARAM_VALUE.LAYER4_VIDEO_FORMAT}
      set_property range_labels [join [dict create 0 {RGB} 1 {YUV 4:4:4} 2 {YUV 4:2:2} 3 {YUV 4:2:0} 5 {RGBA} 6 { YUVA 4:4:4}] ,] ${PARAM_VALUE.LAYER4_VIDEO_FORMAT}
    }
}

proc update_PARAM_VALUE.LAYER5_VIDEO_FORMAT {PARAM_VALUE.LAYER5_INTF_TYPE PARAM_VALUE.LAYER5_VIDEO_FORMAT PARAM_VALUE.MAX_DATA_WIDTH IPINST} {
    set intf_type [get_property value ${PARAM_VALUE.LAYER5_INTF_TYPE} ]
    set bpc [get_property value ${PARAM_VALUE.MAX_DATA_WIDTH} ]
    if {$intf_type == 0} {
      if {$bpc > 8} {
        set_property range "10,27,11,12,28,13,26,14,15,16,17,18,19,20,29,21,22,23,24,25" ${PARAM_VALUE.LAYER5_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 14 {YUVA8} 15 {RGBX10} 16 {YUVX10} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 22 {Y_UV10} 23 {Y_UV10 420} 24 {Y8} 25 {Y10} 26 {BGRA8}] ,] ${PARAM_VALUE.LAYER5_VIDEO_FORMAT}
      } else {
        set_property range "10,27,11,12,28,13,26,14,17,18,19,20,29,21,24" ${PARAM_VALUE.LAYER5_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 26 {BGRA8} 14 {YUVA8} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 24 {Y8} ] ,] ${PARAM_VALUE.LAYER5_VIDEO_FORMAT}
      }
    } else {
      set_property range "0,1,2,3,5,6" ${PARAM_VALUE.LAYER5_VIDEO_FORMAT}
      set_property range_labels [join [dict create 0 {RGB} 1 {YUV 4:4:4} 2 {YUV 4:2:2} 3 {YUV 4:2:0} 5 {RGBA} 6 { YUVA 4:4:4}] ,] ${PARAM_VALUE.LAYER5_VIDEO_FORMAT}
    }
}

proc update_PARAM_VALUE.LAYER6_VIDEO_FORMAT {PARAM_VALUE.LAYER6_INTF_TYPE PARAM_VALUE.LAYER6_VIDEO_FORMAT PARAM_VALUE.MAX_DATA_WIDTH IPINST} {
    set intf_type [get_property value ${PARAM_VALUE.LAYER6_INTF_TYPE} ]
    set bpc [get_property value ${PARAM_VALUE.MAX_DATA_WIDTH} ]
    if {$intf_type == 0} {
      if {$bpc > 8} {
        set_property range "10,27,11,12,28,13,26,14,15,16,17,18,19,20,29,21,22,23,24,25" ${PARAM_VALUE.LAYER6_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 14 {YUVA8} 15 {RGBX10} 16 {YUVX10} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 22 {Y_UV10} 23 {Y_UV10 420} 24 {Y8} 25 {Y10} 26 {BGRA8}] ,] ${PARAM_VALUE.LAYER6_VIDEO_FORMAT}
      } else {
        set_property range "10,27,11,12,28,13,26,14,17,18,19,20,29,21,24" ${PARAM_VALUE.LAYER6_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 26 {BGRA8} 14 {YUVA8} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 24 {Y8} ] ,] ${PARAM_VALUE.LAYER6_VIDEO_FORMAT}
      }
    } else {
      set_property range "0,1,2,3,5,6" ${PARAM_VALUE.LAYER6_VIDEO_FORMAT}
      set_property range_labels [join [dict create 0 {RGB} 1 {YUV 4:4:4} 2 {YUV 4:2:2} 3 {YUV 4:2:0} 5 {RGBA} 6 { YUVA 4:4:4}] ,] ${PARAM_VALUE.LAYER6_VIDEO_FORMAT}
    }
}

proc update_PARAM_VALUE.LAYER7_VIDEO_FORMAT {PARAM_VALUE.LAYER7_INTF_TYPE PARAM_VALUE.LAYER7_VIDEO_FORMAT PARAM_VALUE.MAX_DATA_WIDTH IPINST} {
    set intf_type [get_property value ${PARAM_VALUE.LAYER7_INTF_TYPE} ]
    set bpc [get_property value ${PARAM_VALUE.MAX_DATA_WIDTH} ]
    if {$intf_type == 0} {
      if {$bpc > 8} {
        set_property range "10,27,11,12,28,13,26,14,15,16,17,18,19,20,29,21,22,23,24,25" ${PARAM_VALUE.LAYER7_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 14 {YUVA8} 15 {RGBX10} 16 {YUVX10} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 22 {Y_UV10} 23 {Y_UV10 420} 24 {Y8} 25 {Y10} 26 {BGRA8}] ,] ${PARAM_VALUE.LAYER7_VIDEO_FORMAT}
      } else {
        set_property range "10,27,11,12,28,13,26,14,17,18,19,20,29,21,24" ${PARAM_VALUE.LAYER7_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 26 {BGRA8} 14 {YUVA8} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 24 {Y8} ] ,] ${PARAM_VALUE.LAYER7_VIDEO_FORMAT}
      }
    } else {
      set_property range "0,1,2,3,5,6" ${PARAM_VALUE.LAYER7_VIDEO_FORMAT}
      set_property range_labels [join [dict create 0 {RGB} 1 {YUV 4:4:4} 2 {YUV 4:2:2} 3 {YUV 4:2:0} 5 {RGBA} 6 { YUVA 4:4:4}] ,] ${PARAM_VALUE.LAYER7_VIDEO_FORMAT}
    }
}

proc update_PARAM_VALUE.LAYER8_VIDEO_FORMAT {PARAM_VALUE.LAYER8_INTF_TYPE PARAM_VALUE.LAYER8_VIDEO_FORMAT PARAM_VALUE.MAX_DATA_WIDTH IPINST} {
    set intf_type [get_property value ${PARAM_VALUE.LAYER8_INTF_TYPE} ]
    set bpc [get_property value ${PARAM_VALUE.MAX_DATA_WIDTH} ]
    if {$intf_type == 0} {
      if {$bpc > 8} {
        set_property range "10,27,11,12,28,13,26,14,15,16,17,18,19,20,29,21,22,23,24,25" ${PARAM_VALUE.LAYER8_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 14 {YUVA8} 15 {RGBX10} 16 {YUVX10} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 22 {Y_UV10} 23 {Y_UV10 420} 24 {Y8} 25 {Y10} 26 {BGRA8}] ,] ${PARAM_VALUE.LAYER8_VIDEO_FORMAT}
      } else {
        set_property range "10,27,11,12,28,13,26,14,17,18,19,20,29,21,24" ${PARAM_VALUE.LAYER8_VIDEO_FORMAT}
        set_property range_labels [join [dict create 10 {RGBX8} 27 {BGRX8} 11 {YUVX8} 12 {YUYV8} 28 {UYVY8} 13 {RGBA8} 26 {BGRA8} 14 {YUVA8} 17 {RGB565} 18 {Y_UV8} 19 {Y_UV8 420} 20 {RGB8} 29 {BGR8} 21 {YUV8} 24 {Y8} ] ,] ${PARAM_VALUE.LAYER8_VIDEO_FORMAT}
      }
    } else {
      set_property range "0,1,2,3,5,6" ${PARAM_VALUE.LAYER8_VIDEO_FORMAT}
      set_property range_labels [join [dict create 0 {RGB} 1 {YUV 4:4:4} 2 {YUV 4:2:2} 3 {YUV 4:2:0} 5 {RGBA} 6 { YUVA 4:4:4}] ,] ${PARAM_VALUE.LAYER8_VIDEO_FORMAT}
    }
}

proc update_PARAM_VALUE.LAYER1_ALPHA {PARAM_VALUE.LAYER1_VIDEO_FORMAT PARAM_VALUE.LAYER1_ALPHA IPINST} {
    set format [get_property value ${PARAM_VALUE.LAYER1_VIDEO_FORMAT} ]
    if {($format == 13) || ($format == 14) || ($format == 26) || ($format == 5) || ($format == 6)} {
        set_property value true ${PARAM_VALUE.LAYER1_ALPHA}
        set_property enabled false ${PARAM_VALUE.LAYER1_ALPHA}
    } else {
        set_property enabled true ${PARAM_VALUE.LAYER1_ALPHA}
    }
}

proc update_PARAM_VALUE.LAYER2_ALPHA {PARAM_VALUE.LAYER2_VIDEO_FORMAT PARAM_VALUE.LAYER2_ALPHA IPINST} {
    set format [get_property value ${PARAM_VALUE.LAYER2_VIDEO_FORMAT} ]
    if {($format == 13) || ($format == 14) || ($format == 26) || ($format == 5) || ($format == 6)} {
        set_property value true ${PARAM_VALUE.LAYER2_ALPHA}
        set_property enabled false ${PARAM_VALUE.LAYER2_ALPHA}
    } else {
        set_property enabled true ${PARAM_VALUE.LAYER2_ALPHA}
    }
}

proc update_PARAM_VALUE.LAYER3_ALPHA {PARAM_VALUE.LAYER3_VIDEO_FORMAT PARAM_VALUE.LAYER3_ALPHA IPINST} {
    set format [get_property value ${PARAM_VALUE.LAYER3_VIDEO_FORMAT} ]
    if {($format == 13) || ($format == 14) || ($format == 26) || ($format == 5) || ($format == 6)} {
        set_property value true ${PARAM_VALUE.LAYER3_ALPHA}
        set_property enabled false ${PARAM_VALUE.LAYER3_ALPHA}
    } else {
        set_property enabled true ${PARAM_VALUE.LAYER3_ALPHA}
    }
}

proc update_PARAM_VALUE.LAYER4_ALPHA {PARAM_VALUE.LAYER4_VIDEO_FORMAT PARAM_VALUE.LAYER4_ALPHA IPINST} {
    set format [get_property value ${PARAM_VALUE.LAYER4_VIDEO_FORMAT} ]
    if {($format == 13) || ($format == 14) || ($format == 26) || ($format == 5) || ($format == 6)} {
        set_property value true ${PARAM_VALUE.LAYER4_ALPHA}
        set_property enabled false ${PARAM_VALUE.LAYER4_ALPHA}
    } else {
        set_property enabled true ${PARAM_VALUE.LAYER4_ALPHA}
    }
}

proc update_PARAM_VALUE.LAYER5_ALPHA {PARAM_VALUE.LAYER5_VIDEO_FORMAT PARAM_VALUE.LAYER5_ALPHA IPINST} {
    set format [get_property value ${PARAM_VALUE.LAYER5_VIDEO_FORMAT} ]
    if {($format == 13) || ($format == 14) || ($format == 26) || ($format == 5) || ($format == 6)} {
        set_property value true ${PARAM_VALUE.LAYER5_ALPHA}
        set_property enabled false ${PARAM_VALUE.LAYER5_ALPHA}
    } else {
        set_property enabled true ${PARAM_VALUE.LAYER5_ALPHA}
    }
}

proc update_PARAM_VALUE.LAYER6_ALPHA {PARAM_VALUE.LAYER6_VIDEO_FORMAT PARAM_VALUE.LAYER6_ALPHA IPINST} {
    set format [get_property value ${PARAM_VALUE.LAYER6_VIDEO_FORMAT} ]
    if {($format == 13) || ($format == 14) || ($format == 26) || ($format == 5) || ($format == 6)} {
        set_property value true ${PARAM_VALUE.LAYER6_ALPHA}
        set_property enabled false ${PARAM_VALUE.LAYER6_ALPHA}
    } else {
        set_property enabled true ${PARAM_VALUE.LAYER6_ALPHA}
    }
}

proc update_PARAM_VALUE.LAYER7_ALPHA {PARAM_VALUE.LAYER7_VIDEO_FORMAT PARAM_VALUE.LAYER7_ALPHA IPINST} {
    set format [get_property value ${PARAM_VALUE.LAYER7_VIDEO_FORMAT} ]
    if {($format == 13) || ($format == 14) || ($format == 26) || ($format == 5) || ($format == 6)} {
        set_property value true ${PARAM_VALUE.LAYER7_ALPHA}
        set_property enabled false ${PARAM_VALUE.LAYER7_ALPHA}
    } else {
        set_property enabled true ${PARAM_VALUE.LAYER7_ALPHA}
    }
}

proc update_PARAM_VALUE.LAYER8_ALPHA {PARAM_VALUE.LAYER8_VIDEO_FORMAT PARAM_VALUE.LAYER8_ALPHA IPINST} {
    set format [get_property value ${PARAM_VALUE.LAYER8_VIDEO_FORMAT} ]
    if {($format == 13) || ($format == 14) || ($format == 26) || ($format == 5) || ($format == 6)} {
        set_property value true ${PARAM_VALUE.LAYER8_ALPHA}
        set_property enabled false ${PARAM_VALUE.LAYER8_ALPHA}
    } else {
        set_property enabled true ${PARAM_VALUE.LAYER8_ALPHA}
    }
}

proc update_PARAM_VALUE.USE_URAM { PARAM_VALUE.USE_URAM } {
    # Procedure called to update USE_URAM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.USE_URAM { PARAM_VALUE.USE_URAM } {
    # Procedure called to validate USE_URAM
    return true
}

proc update_PARAM_VALUE.C_M_AXI_MM_VIDEO1_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO1_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to update C_M_AXI_MM_VIDEO1_DATA_WIDTH when any of the dependent parameters in the arguments change
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${PARAM_VALUE.C_M_AXI_MM_VIDEO1_DATA_WIDTH}
}

proc validate_PARAM_VALUE.C_M_AXI_MM_VIDEO1_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO1_DATA_WIDTH } {
    # Procedure called to validate C_M_AXI_MM_VIDEO1_DATA_WIDTH
    return true
}

proc update_PARAM_VALUE.C_M_AXI_MM_VIDEO2_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO2_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to update C_M_AXI_MM_VIDEO2_DATA_WIDTH when any of the dependent parameters in the arguments change
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${PARAM_VALUE.C_M_AXI_MM_VIDEO2_DATA_WIDTH}
}

proc validate_PARAM_VALUE.C_M_AXI_MM_VIDEO2_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO2_DATA_WIDTH } {
    # Procedure called to validate C_M_AXI_MM_VIDEO2_DATA_WIDTH
    return true
}
proc update_PARAM_VALUE.C_M_AXI_MM_VIDEO3_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO3_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to update C_M_AXI_MM_VIDEO3_DATA_WIDTH when any of the dependent parameters in the arguments change
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${PARAM_VALUE.C_M_AXI_MM_VIDEO3_DATA_WIDTH}
}

proc validate_PARAM_VALUE.C_M_AXI_MM_VIDEO3_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO3_DATA_WIDTH } {
    # Procedure called to validate C_M_AXI_MM_VIDEO3_DATA_WIDTH
    return true
}
proc update_PARAM_VALUE.C_M_AXI_MM_VIDEO4_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO4_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to update C_M_AXI_MM_VIDEO4_DATA_WIDTH when any of the dependent parameters in the arguments change
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${PARAM_VALUE.C_M_AXI_MM_VIDEO4_DATA_WIDTH}
}

proc validate_PARAM_VALUE.C_M_AXI_MM_VIDEO4_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO4_DATA_WIDTH } {
    # Procedure called to validate C_M_AXI_MM_VIDEO4_DATA_WIDTH
    return true
}
proc update_PARAM_VALUE.C_M_AXI_MM_VIDEO5_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO5_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to update C_M_AXI_MM_VIDEO5_DATA_WIDTH when any of the dependent parameters in the arguments change
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${PARAM_VALUE.C_M_AXI_MM_VIDEO5_DATA_WIDTH}
}

proc validate_PARAM_VALUE.C_M_AXI_MM_VIDEO5_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO5_DATA_WIDTH } {
    # Procedure called to validate C_M_AXI_MM_VIDEO5_DATA_WIDTH
    return true
}
proc update_PARAM_VALUE.C_M_AXI_MM_VIDEO6_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO6_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to update C_M_AXI_MM_VIDEO6_DATA_WIDTH when any of the dependent parameters in the arguments change
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${PARAM_VALUE.C_M_AXI_MM_VIDEO6_DATA_WIDTH}
}

proc validate_PARAM_VALUE.C_M_AXI_MM_VIDEO6_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO6_DATA_WIDTH } {
    # Procedure called to validate C_M_AXI_MM_VIDEO6_DATA_WIDTH
    return true
}
proc update_PARAM_VALUE.C_M_AXI_MM_VIDEO7_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO7_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to update C_M_AXI_MM_VIDEO7_DATA_WIDTH when any of the dependent parameters in the arguments change
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${PARAM_VALUE.C_M_AXI_MM_VIDEO7_DATA_WIDTH}
}

proc validate_PARAM_VALUE.C_M_AXI_MM_VIDEO7_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO7_DATA_WIDTH } {
    # Procedure called to validate C_M_AXI_MM_VIDEO7_DATA_WIDTH
    return true
}
proc update_PARAM_VALUE.C_M_AXI_MM_VIDEO8_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO8_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to update C_M_AXI_MM_VIDEO8_DATA_WIDTH when any of the dependent parameters in the arguments change
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${PARAM_VALUE.C_M_AXI_MM_VIDEO8_DATA_WIDTH}
}

proc validate_PARAM_VALUE.C_M_AXI_MM_VIDEO8_DATA_WIDTH { PARAM_VALUE.C_M_AXI_MM_VIDEO8_DATA_WIDTH } {
    # Procedure called to validate C_M_AXI_MM_VIDEO8_DATA_WIDTH
    return true
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO1_DATA_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO1_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO1_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO2_DATA_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO2_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO2_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO3_DATA_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO3_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO3_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO4_DATA_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO4_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO4_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO5_DATA_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO5_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO5_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO6_DATA_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO6_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO6_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO7_DATA_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO7_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO7_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO8_DATA_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO8_DATA_WIDTH PARAM_VALUE.AXIMM_DATA_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO8_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO1_ADDR_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO1_ADDR_WIDTH PARAM_VALUE.AXIMM_ADDR_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO1_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO2_ADDR_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO2_ADDR_WIDTH PARAM_VALUE.AXIMM_ADDR_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO2_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO3_ADDR_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO3_ADDR_WIDTH PARAM_VALUE.AXIMM_ADDR_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO3_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO4_ADDR_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO4_ADDR_WIDTH PARAM_VALUE.AXIMM_ADDR_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO4_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO5_ADDR_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO5_ADDR_WIDTH PARAM_VALUE.AXIMM_ADDR_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO5_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO6_ADDR_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO6_ADDR_WIDTH PARAM_VALUE.AXIMM_ADDR_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO6_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO7_ADDR_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO7_ADDR_WIDTH PARAM_VALUE.AXIMM_ADDR_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO7_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_MM_VIDEO8_ADDR_WIDTH { MODELPARAM_VALUE.C_M_AXI_MM_VIDEO8_ADDR_WIDTH PARAM_VALUE.AXIMM_ADDR_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set_property value [get_property value ${PARAM_VALUE.AXIMM_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_MM_VIDEO8_ADDR_WIDTH}
}
