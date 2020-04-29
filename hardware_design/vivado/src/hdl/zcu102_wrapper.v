//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
//Date        : Wed Apr 29 20:05:41 2020
//Host        : soc running 64-bit Ubuntu 18.04.4 LTS
//Command     : generate_target zcu102_wrapper.bd
//Design      : zcu102_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module zcu102_wrapper
   (hdmi_ctl_iic_scl_io,
    hdmi_ctl_iic_sda_io,
    hdmi_tx_clk_n_out,
    hdmi_tx_clk_p_out,
    hdmi_tx_dat_n_out,
    hdmi_tx_dat_p_out,
    hdmi_tx_ddc_out_scl_io,
    hdmi_tx_ddc_out_sda_io,
    hdmi_tx_en_out,
    hdmi_tx_hb_led,
    hdmi_tx_hpd_in,
    hdmi_tx_locked_led,
    reset,
    si5324_clk_n_in,
    si5324_clk_p_in,
    si5324_lol_in,
    si5324_rst_out);
  inout hdmi_ctl_iic_scl_io;
  inout hdmi_ctl_iic_sda_io;
  output hdmi_tx_clk_n_out;
  output hdmi_tx_clk_p_out;
  output [2:0]hdmi_tx_dat_n_out;
  output [2:0]hdmi_tx_dat_p_out;
  inout hdmi_tx_ddc_out_scl_io;
  inout hdmi_tx_ddc_out_sda_io;
  output [0:0]hdmi_tx_en_out;
  output hdmi_tx_hb_led;
  input hdmi_tx_hpd_in;
  output hdmi_tx_locked_led;
  input reset;
  input si5324_clk_n_in;
  input si5324_clk_p_in;
  input si5324_lol_in;
  output [0:0]si5324_rst_out;

  wire hdmi_ctl_iic_scl_i;
  wire hdmi_ctl_iic_scl_io;
  wire hdmi_ctl_iic_scl_o;
  wire hdmi_ctl_iic_scl_t;
  wire hdmi_ctl_iic_sda_i;
  wire hdmi_ctl_iic_sda_io;
  wire hdmi_ctl_iic_sda_o;
  wire hdmi_ctl_iic_sda_t;
  wire hdmi_tx_clk_n_out;
  wire hdmi_tx_clk_p_out;
  wire [2:0]hdmi_tx_dat_n_out;
  wire [2:0]hdmi_tx_dat_p_out;
  wire hdmi_tx_ddc_out_scl_i;
  wire hdmi_tx_ddc_out_scl_io;
  wire hdmi_tx_ddc_out_scl_o;
  wire hdmi_tx_ddc_out_scl_t;
  wire hdmi_tx_ddc_out_sda_i;
  wire hdmi_tx_ddc_out_sda_io;
  wire hdmi_tx_ddc_out_sda_o;
  wire hdmi_tx_ddc_out_sda_t;
  wire [0:0]hdmi_tx_en_out;
  wire hdmi_tx_hb_led;
  wire hdmi_tx_hpd_in;
  wire hdmi_tx_locked_led;
  wire reset;
  wire si5324_clk_n_in;
  wire si5324_clk_p_in;
  wire si5324_lol_in;
  wire [0:0]si5324_rst_out;

  IOBUF hdmi_ctl_iic_scl_iobuf
       (.I(hdmi_ctl_iic_scl_o),
        .IO(hdmi_ctl_iic_scl_io),
        .O(hdmi_ctl_iic_scl_i),
        .T(hdmi_ctl_iic_scl_t));
  IOBUF hdmi_ctl_iic_sda_iobuf
       (.I(hdmi_ctl_iic_sda_o),
        .IO(hdmi_ctl_iic_sda_io),
        .O(hdmi_ctl_iic_sda_i),
        .T(hdmi_ctl_iic_sda_t));
  IOBUF hdmi_tx_ddc_out_scl_iobuf
       (.I(hdmi_tx_ddc_out_scl_o),
        .IO(hdmi_tx_ddc_out_scl_io),
        .O(hdmi_tx_ddc_out_scl_i),
        .T(hdmi_tx_ddc_out_scl_t));
  IOBUF hdmi_tx_ddc_out_sda_iobuf
       (.I(hdmi_tx_ddc_out_sda_o),
        .IO(hdmi_tx_ddc_out_sda_io),
        .O(hdmi_tx_ddc_out_sda_i),
        .T(hdmi_tx_ddc_out_sda_t));
  zcu102 zcu102_i
       (.hdmi_ctl_iic_scl_i(hdmi_ctl_iic_scl_i),
        .hdmi_ctl_iic_scl_o(hdmi_ctl_iic_scl_o),
        .hdmi_ctl_iic_scl_t(hdmi_ctl_iic_scl_t),
        .hdmi_ctl_iic_sda_i(hdmi_ctl_iic_sda_i),
        .hdmi_ctl_iic_sda_o(hdmi_ctl_iic_sda_o),
        .hdmi_ctl_iic_sda_t(hdmi_ctl_iic_sda_t),
        .hdmi_tx_clk_n_out(hdmi_tx_clk_n_out),
        .hdmi_tx_clk_p_out(hdmi_tx_clk_p_out),
        .hdmi_tx_dat_n_out(hdmi_tx_dat_n_out),
        .hdmi_tx_dat_p_out(hdmi_tx_dat_p_out),
        .hdmi_tx_ddc_out_scl_i(hdmi_tx_ddc_out_scl_i),
        .hdmi_tx_ddc_out_scl_o(hdmi_tx_ddc_out_scl_o),
        .hdmi_tx_ddc_out_scl_t(hdmi_tx_ddc_out_scl_t),
        .hdmi_tx_ddc_out_sda_i(hdmi_tx_ddc_out_sda_i),
        .hdmi_tx_ddc_out_sda_o(hdmi_tx_ddc_out_sda_o),
        .hdmi_tx_ddc_out_sda_t(hdmi_tx_ddc_out_sda_t),
        .hdmi_tx_en_out(hdmi_tx_en_out),
        .hdmi_tx_hb_led(hdmi_tx_hb_led),
        .hdmi_tx_hpd_in(hdmi_tx_hpd_in),
        .hdmi_tx_locked_led(hdmi_tx_locked_led),
        .reset(reset),
        .si5324_clk_n_in(si5324_clk_n_in),
        .si5324_clk_p_in(si5324_clk_p_in),
        .si5324_lol_in(si5324_lol_in),
        .si5324_rst_out(si5324_rst_out));
endmodule
