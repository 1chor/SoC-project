#####
## Constraints for ZCU102
## Version 1.0
#####


#####
## Pins
#####


#####
## Reset (Switch West / SW14)
set_property PACKAGE_PIN AF15 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
#####


#####
## USER_MGT_SI570_CLOCK1
#set_property PACKAGE_PIN L27 [get_ports DRU_CLK_IN_clk_p]
#set_property PACKAGE_PIN L28 [get_ports DRU_CLK_IN_clk_n]
#####


#####
## HDMI TX
# HDMI TX DATA
set_property PACKAGE_PIN T29 [get_ports {HDMI_TX_DAT_P_OUT[0]}]
set_property PACKAGE_PIN T30 [get_ports {HDMI_TX_DAT_N_OUT[0]}]

set_property PACKAGE_PIN R31 [get_ports {HDMI_TX_DAT_P_OUT[1]}]
set_property PACKAGE_PIN R32 [get_ports {HDMI_TX_DAT_N_OUT[1]}]

set_property PACKAGE_PIN P29 [get_ports {HDMI_TX_DAT_P_OUT[2]}]
set_property PACKAGE_PIN P30 [get_ports {HDMI_TX_DAT_N_OUT[2]}]

# HDMI TX CLK
set_property PACKAGE_PIN AF6 [get_ports HDMI_TX_CLK_P_OUT]
set_property IOSTANDARD LVDS [get_ports HDMI_TX_CLK_P_OUT]

set_property PACKAGE_PIN AG6 [get_ports HDMI_TX_CLK_N_OUT]
set_property IOSTANDARD LVDS [get_ports HDMI_TX_CLK_N_OUT]

# HDMI TX I2C
set_property PACKAGE_PIN C16 [get_ports TX_DDC_OUT_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports TX_DDC_OUT_scl_io]

set_property PACKAGE_PIN D16 [get_ports TX_DDC_OUT_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports TX_DDC_OUT_sda_io]

#HDMI TX EN
set_property PACKAGE_PIN B15 [get_ports TX_EN_OUT]
set_property IOSTANDARD LVCMOS33 [get_ports TX_EN_OUT]

# HDMI TX HPD
set_property PACKAGE_PIN B16 [get_ports TX_HPD_IN]
set_property IOSTANDARD LVCMOS33 [get_ports TX_HPD_IN]

# HDMI TX REFCLK
set_property PACKAGE_PIN R27 [get_ports TX_REFCLK_P_IN]
set_property PACKAGE_PIN R28 [get_ports TX_REFCLK_N_IN]
#####


#####
## HDMI RX
# HDMI RX DATA
#set_property PACKAGE_PIN T33 [get_ports {HDMI_RX_DAT_P_IN[0]}]
#set_property PACKAGE_PIN T34 [get_ports {HDMI_RX_DAT_N_IN[0]}]

#set_property PACKAGE_PIN P33 [get_ports {HDMI_RX_DAT_P_IN[1]}]
#set_property PACKAGE_PIN P34 [get_ports {HDMI_RX_DAT_N_IN[1]}]

#set_property PACKAGE_PIN N31 [get_ports {HDMI_RX_DAT_P_IN[2]}]
#set_property PACKAGE_PIN N32 [get_ports {HDMI_RX_DAT_N_IN[2]}]

# HDMI RX CLK
#set_property PACKAGE_PIN N27 [get_ports HDMI_RX_CLK_P_IN];
#set_property PACKAGE_PIN N28 [get_ports HDMI_RX_CLK_N_IN];

# HDMI RX I2C
#set_property PACKAGE_PIN E15 [get_ports RX_DDC_OUT_scl_io]
#set_property IOSTANDARD LVCMOS33 [get_ports RX_DDC_OUT_scl_io]

#set_property PACKAGE_PIN A15 [get_ports RX_DDC_OUT_sda_io]
#set_property IOSTANDARD LVCMOS33 [get_ports RX_DDC_OUT_sda_io]

# HDMI RX PWR DET
#set_property PACKAGE_PIN D14 [get_ports RX_DET_IN]
#set_property IOSTANDARD LVCMOS33 [get_ports RX_DET_IN]

# HDMI RX HPD
#set_property PACKAGE_PIN E14 [get_ports RX_HPD_OUT]
#set_property IOSTANDARD LVCMOS33 [get_ports RX_HPD_OUT]

# HDMI RX REFCLK
#set_property PACKAGE_PIN AG5 [get_ports RX_REFCLK_P_OUT]
#set_property IOSTANDARD LVDS [get_ports RX_REFCLK_P_OUT]

#set_property PACKAGE_PIN AG4 [get_ports RX_REFCLK_N_OUT]
#set_property IOSTANDARD LVDS [get_ports RX_REFCLK_N_OUT]
#####


#####
## HDMI SI5324
# SI5324 LOL
set_property PACKAGE_PIN H12 [get_ports SI5324_LOL_IN]          
set_property IOSTANDARD LVCMOS33 [get_ports SI5324_LOL_IN]

# SI5324 RST
set_property PACKAGE_PIN J12 [get_ports SI5324_RST_OUT]
set_property IOSTANDARD LVCMOS33 [get_ports SI5324_RST_OUT]
#####


#####
## I2C
set_property PACKAGE_PIN F15 [get_ports fmch_iic_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports fmch_iic_scl_io]

set_property PACKAGE_PIN F16 [get_ports fmch_iic_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports fmch_iic_sda_io]
#####


#####
## Misc
#GPIO_LEDs
#set_property PACKAGE_PIN AG14 [get_ports {LED0}] # for HDMI
#set_property PACKAGE_PIN AF13 [get_ports {LED1}] # for HDMI

set_property PACKAGE_PIN AG14 [get_ports {LED[0]}]
set_property PACKAGE_PIN AF13 [get_ports {LED[1]}]
set_property PACKAGE_PIN AE13 [get_ports {LED[2]}]
set_property PACKAGE_PIN AJ14 [get_ports {LED[3]}]           
set_property PACKAGE_PIN AJ15 [get_ports {LED[4]}]           
set_property PACKAGE_PIN AH13 [get_ports {LED[5]}]           
set_property PACKAGE_PIN AH14 [get_ports {LED[6]}]           
set_property PACKAGE_PIN AL12 [get_ports {LED[7]}]                 

#set_property IOSTANDARD LVCMOS33 [get_ports {LED0}] # for HDMI
#set_property IOSTANDARD LVCMOS33 [get_ports {LED1}] # for HDMI

set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]
#####
   

#####
## End
#####
