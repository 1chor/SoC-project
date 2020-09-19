--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
--Date        : Thu Sep 17 19:32:56 2020
--Host        : soc running 64-bit Ubuntu 18.04.5 LTS
--Command     : generate_target zcu102_wrapper.bd
--Design      : zcu102_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------

entity zcu102_wrapper is
  port (
    HDMI_TX_CLK_N_OUT : out STD_LOGIC;
    HDMI_TX_CLK_P_OUT : out STD_LOGIC;
    HDMI_TX_DAT_N_OUT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    HDMI_TX_DAT_P_OUT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    LED : out STD_LOGIC_VECTOR ( 7 downto 0 );
    SI5324_LOL_IN : in STD_LOGIC;
    SI5324_RST_OUT : out STD_LOGIC_VECTOR ( 0 to 0 );
    TX_DDC_OUT_scl_io : inout STD_LOGIC;
    TX_DDC_OUT_sda_io : inout STD_LOGIC;
    TX_EN_OUT : out STD_LOGIC_VECTOR ( 0 to 0 );
    TX_HPD_IN : in STD_LOGIC;
    TX_REFCLK_N_IN : in STD_LOGIC;
    TX_REFCLK_P_IN : in STD_LOGIC;
    fmch_iic_scl_io : inout STD_LOGIC;
    fmch_iic_sda_io : inout STD_LOGIC;
    reset : in STD_LOGIC
  );
end zcu102_wrapper;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture STRUCTURE of zcu102_wrapper is

  ------------------------------------------
  -- declare block diagram instance
  ------------------------------------------
  
  component zcu102 is
  port (
    TX_EN_OUT : out STD_LOGIC_VECTOR ( 0 to 0 );
    HDMI_TX_CLK_N_OUT : out STD_LOGIC;
    HDMI_TX_CLK_P_OUT : out STD_LOGIC;
    HDMI_TX_DAT_N_OUT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    HDMI_TX_DAT_P_OUT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    TX_HPD_IN : in STD_LOGIC;
    LED : out STD_LOGIC_VECTOR ( 7 downto 0 );
    reset : in STD_LOGIC;
    TX_REFCLK_N_IN : in STD_LOGIC;
    TX_REFCLK_P_IN : in STD_LOGIC;
    SI5324_LOL_IN : in STD_LOGIC;
    SI5324_RST_OUT : out STD_LOGIC_VECTOR ( 0 to 0 );
    fmch_iic_scl_i : in STD_LOGIC;
    fmch_iic_scl_o : out STD_LOGIC;
    fmch_iic_scl_t : out STD_LOGIC;
    fmch_iic_sda_i : in STD_LOGIC;
    fmch_iic_sda_o : out STD_LOGIC;
    fmch_iic_sda_t : out STD_LOGIC;
    TX_DDC_OUT_scl_i : in STD_LOGIC;
    TX_DDC_OUT_scl_o : out STD_LOGIC;
    TX_DDC_OUT_scl_t : out STD_LOGIC;
    TX_DDC_OUT_sda_i : in STD_LOGIC;
    TX_DDC_OUT_sda_o : out STD_LOGIC;
    TX_DDC_OUT_sda_t : out STD_LOGIC;
    M05_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M05_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M05_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M05_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_aclk : out STD_LOGIC;
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M05_AXI_arid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M05_AXI_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M05_AXI_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M05_AXI_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M05_AXI_arregion : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M05_AXI_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M05_AXI_aruser : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M05_AXI_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M05_AXI_awid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M05_AXI_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M05_AXI_awlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M05_AXI_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M05_AXI_awregion : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M05_AXI_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M05_AXI_awuser : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M05_AXI_bid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    M05_AXI_rid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    M05_AXI_rlast : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_wlast : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component zcu102;
  
  ------------------------------------------
  -- declare IOBUF instance
  ------------------------------------------
  
  component IOBUF is
  port (
    I : in STD_LOGIC;
    O : out STD_LOGIC;
    T : in STD_LOGIC;
    IO : inout STD_LOGIC
  );
  end component IOBUF;
  
  ------------------------------------------
  -- declare simple_filter instance
  ------------------------------------------
  
  component simple_filter is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------
  
    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_S_AXI_DATA_WIDTH             : integer              := 32;
    C_S_AXI_ADDR_WIDTH             : integer              := 32;
    C_S_AXI_MIN_SIZE               : std_logic_vector     := X"000001FF";
    C_USE_WSTRB                    : integer              := 0;
    C_DPHASE_TIMEOUT               : integer              := 8;
    C_BASEADDR                     : std_logic_vector     := X"98000000";
    C_HIGHADDR                     : std_logic_vector     := X"9800FFFF";
    C_FAMILY                       : string               := "virtex6";
    C_NUM_REG                      : integer              := 1;
    C_NUM_MEM                      : integer              := 1;
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------
    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    S_AXI_ACLK                     : in  std_logic;
    S_AXI_ARESETN                  : in  std_logic;
    S_AXI_AWADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID                  : in  std_logic;
    S_AXI_WDATA                    : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB                    : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID                   : in  std_logic;
    S_AXI_BREADY                   : in  std_logic;
    S_AXI_ARADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID                  : in  std_logic;
    S_AXI_RREADY                   : in  std_logic;
    S_AXI_ARREADY                  : out std_logic;
    S_AXI_RDATA                    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_RVALID                   : out std_logic;
    S_AXI_WREADY                   : out std_logic;
    S_AXI_BRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_BVALID                   : out std_logic;
    S_AXI_AWREADY                  : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  end component simple_filter;
  
  ------------------------------------------
  -- external signal declarations
  ------------------------------------------
  
  signal TX_DDC_OUT_scl_i : STD_LOGIC;
  signal TX_DDC_OUT_scl_o : STD_LOGIC;
  signal TX_DDC_OUT_scl_t : STD_LOGIC;
  signal TX_DDC_OUT_sda_i : STD_LOGIC;
  signal TX_DDC_OUT_sda_o : STD_LOGIC;
  signal TX_DDC_OUT_sda_t : STD_LOGIC;
  signal fmch_iic_scl_i : STD_LOGIC;
  signal fmch_iic_scl_o : STD_LOGIC;
  signal fmch_iic_scl_t : STD_LOGIC;
  signal fmch_iic_sda_i : STD_LOGIC;
  signal fmch_iic_sda_o : STD_LOGIC;
  signal fmch_iic_sda_t : STD_LOGIC;
  
  ------------------------------------------
  -- simple_filter signal declarations
  ------------------------------------------
  
  signal s_axi_aclk : STD_LOGIC;
  signal peripheral_aresetn : STD_LOGIC_VECTOR ( 0 to 0 );
  -- S_AXI interface
  signal M05_AXI_araddr : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal M05_AXI_arburst : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal M05_AXI_arcache : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal M05_AXI_arid : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal M05_AXI_arlen : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal M05_AXI_arlock : STD_LOGIC_VECTOR ( 0 to 0 );
  signal M05_AXI_arprot : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal M05_AXI_arqos : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal M05_AXI_arready : STD_LOGIC_VECTOR ( 0 to 0 );
  signal M05_AXI_arregion : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal M05_AXI_arsize : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal M05_AXI_aruser : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal M05_AXI_arvalid : STD_LOGIC_VECTOR ( 0 to 0 );
  signal M05_AXI_awaddr : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal M05_AXI_awburst : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal M05_AXI_awcache : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal M05_AXI_awid : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal M05_AXI_awlen : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal M05_AXI_awlock : STD_LOGIC_VECTOR ( 0 to 0 );
  signal M05_AXI_awprot : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal M05_AXI_awqos : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal M05_AXI_awready : STD_LOGIC_VECTOR ( 0 to 0 );
  signal M05_AXI_awregion : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal M05_AXI_awsize : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal M05_AXI_awuser : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal M05_AXI_awvalid : STD_LOGIC_VECTOR ( 0 to 0 );
  signal M05_AXI_bid : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal M05_AXI_bready : STD_LOGIC_VECTOR ( 0 to 0 );
  signal M05_AXI_bresp : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal M05_AXI_bvalid : STD_LOGIC_VECTOR ( 0 to 0 );
  signal M05_AXI_rdata : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal M05_AXI_rid : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal M05_AXI_rlast : STD_LOGIC_VECTOR ( 0 to 0 );
  signal M05_AXI_rready : STD_LOGIC_VECTOR ( 0 to 0 );
  signal M05_AXI_rresp : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal M05_AXI_rvalid : STD_LOGIC_VECTOR ( 0 to 0 );
  signal M05_AXI_wdata : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal M05_AXI_wlast : STD_LOGIC_VECTOR ( 0 to 0 );
  signal M05_AXI_wready : STD_LOGIC_VECTOR ( 0 to 0 );
  signal M05_AXI_wstrb : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal M05_AXI_wvalid : STD_LOGIC_VECTOR ( 0 to 0 );

begin

  ------------------------------------------
  -- instantiate IOBUF for TX_DDC_OUT_scl
  ------------------------------------------
  
  TX_DDC_OUT_scl_iobuf: component IOBUF
    port map (
      I => TX_DDC_OUT_scl_o,
      IO => TX_DDC_OUT_scl_io,
      O => TX_DDC_OUT_scl_i,
      T => TX_DDC_OUT_scl_t
    );
    
  ------------------------------------------
  -- instantiate IOBUF for TX_DDC_OUT_sda
  ------------------------------------------
  
  TX_DDC_OUT_sda_iobuf: component IOBUF
    port map (
      I => TX_DDC_OUT_sda_o,
      IO => TX_DDC_OUT_sda_io,
      O => TX_DDC_OUT_sda_i,
      T => TX_DDC_OUT_sda_t
    );
    
  ------------------------------------------
  -- instantiate IOBUF for fmch_iic_scl
  ------------------------------------------
    
  fmch_iic_scl_iobuf: component IOBUF
    port map (
      I => fmch_iic_scl_o,
      IO => fmch_iic_scl_io,
      O => fmch_iic_scl_i,
      T => fmch_iic_scl_t
    );

  ------------------------------------------
  -- instantiate IOBUF for fmch_iic_sda
  ------------------------------------------
  
  fmch_iic_sda_iobuf: component IOBUF
    port map (
      I => fmch_iic_sda_o,
      IO => fmch_iic_sda_io,
      O => fmch_iic_sda_i,
      T => fmch_iic_sda_t
    );

  ------------------------------------------
  -- instantiate block diagram instance
  ------------------------------------------

  zcu102_i: component zcu102
    port map (
      HDMI_TX_CLK_N_OUT => HDMI_TX_CLK_N_OUT,
      HDMI_TX_CLK_P_OUT => HDMI_TX_CLK_P_OUT,
      HDMI_TX_DAT_N_OUT(2 downto 0) => HDMI_TX_DAT_N_OUT(2 downto 0),
      HDMI_TX_DAT_P_OUT(2 downto 0) => HDMI_TX_DAT_P_OUT(2 downto 0),
      LED(7 downto 0) => LED(7 downto 0),
      M05_AXI_araddr(39 downto 0) => M05_AXI_araddr(39 downto 0),
      M05_AXI_arburst(1 downto 0) => M05_AXI_arburst(1 downto 0),
      M05_AXI_arcache(3 downto 0) => M05_AXI_arcache(3 downto 0),
      M05_AXI_arid(15 downto 0) => M05_AXI_arid(15 downto 0),
      M05_AXI_arlen(7 downto 0) => M05_AXI_arlen(7 downto 0),
      M05_AXI_arlock(0) => M05_AXI_arlock(0),
      M05_AXI_arprot(2 downto 0) => M05_AXI_arprot(2 downto 0),
      M05_AXI_arqos(3 downto 0) => M05_AXI_arqos(3 downto 0),
      M05_AXI_arready(0) => M05_AXI_arready(0),
      M05_AXI_arregion(3 downto 0) => M05_AXI_arregion(3 downto 0),
      M05_AXI_arsize(2 downto 0) => M05_AXI_arsize(2 downto 0),
      M05_AXI_aruser(15 downto 0) => M05_AXI_aruser(15 downto 0),
      M05_AXI_arvalid(0) => M05_AXI_arvalid(0),
      M05_AXI_awaddr(39 downto 0) => M05_AXI_awaddr(39 downto 0),
      M05_AXI_awburst(1 downto 0) => M05_AXI_awburst(1 downto 0),
      M05_AXI_awcache(3 downto 0) => M05_AXI_awcache(3 downto 0),
      M05_AXI_awid(15 downto 0) => M05_AXI_awid(15 downto 0),
      M05_AXI_awlen(7 downto 0) => M05_AXI_awlen(7 downto 0),
      M05_AXI_awlock(0) => M05_AXI_awlock(0),
      M05_AXI_awprot(2 downto 0) => M05_AXI_awprot(2 downto 0),
      M05_AXI_awqos(3 downto 0) => M05_AXI_awqos(3 downto 0),
      M05_AXI_awready(0) => M05_AXI_awready(0),
      M05_AXI_awregion(3 downto 0) => M05_AXI_awregion(3 downto 0),
      M05_AXI_awsize(2 downto 0) => M05_AXI_awsize(2 downto 0),
      M05_AXI_awuser(15 downto 0) => M05_AXI_awuser(15 downto 0),
      M05_AXI_awvalid(0) => M05_AXI_awvalid(0),
      M05_AXI_bid(15 downto 0) => M05_AXI_bid(15 downto 0),
      M05_AXI_bready(0) => M05_AXI_bready(0),
      M05_AXI_bresp(1 downto 0) => M05_AXI_bresp(1 downto 0),
      M05_AXI_bvalid(0) => M05_AXI_bvalid(0),
      M05_AXI_rdata(31 downto 0) => M05_AXI_rdata(31 downto 0),
      M05_AXI_rid(15 downto 0) => M05_AXI_rid(15 downto 0),
      M05_AXI_rlast(0) => M05_AXI_rlast(0),
      M05_AXI_rready(0) => M05_AXI_rready(0),
      M05_AXI_rresp(1 downto 0) => M05_AXI_rresp(1 downto 0),
      M05_AXI_rvalid(0) => M05_AXI_rvalid(0),
      M05_AXI_wdata(31 downto 0) => M05_AXI_wdata(31 downto 0),
      M05_AXI_wlast(0) => M05_AXI_wlast(0),
      M05_AXI_wready(0) => M05_AXI_wready(0),
      M05_AXI_wstrb(3 downto 0) => M05_AXI_wstrb(3 downto 0),
      M05_AXI_wvalid(0) => M05_AXI_wvalid(0),
      SI5324_LOL_IN => SI5324_LOL_IN,
      SI5324_RST_OUT(0) => SI5324_RST_OUT(0),
      TX_DDC_OUT_scl_i => TX_DDC_OUT_scl_i,
      TX_DDC_OUT_scl_o => TX_DDC_OUT_scl_o,
      TX_DDC_OUT_scl_t => TX_DDC_OUT_scl_t,
      TX_DDC_OUT_sda_i => TX_DDC_OUT_sda_i,
      TX_DDC_OUT_sda_o => TX_DDC_OUT_sda_o,
      TX_DDC_OUT_sda_t => TX_DDC_OUT_sda_t,
      TX_EN_OUT(0) => TX_EN_OUT(0),
      TX_HPD_IN => TX_HPD_IN,
      TX_REFCLK_N_IN => TX_REFCLK_N_IN,
      TX_REFCLK_P_IN => TX_REFCLK_P_IN,
      fmch_iic_scl_i => fmch_iic_scl_i,
      fmch_iic_scl_o => fmch_iic_scl_o,
      fmch_iic_scl_t => fmch_iic_scl_t,
      fmch_iic_sda_i => fmch_iic_sda_i,
      fmch_iic_sda_o => fmch_iic_sda_o,
      fmch_iic_sda_t => fmch_iic_sda_t,
      peripheral_aresetn(0) => peripheral_aresetn(0),
      reset => reset,
      s_axi_aclk => s_axi_aclk
    );
    
  ------------------------------------------
  -- instantiate block diagram instance
  ------------------------------------------
  
  simple_filter_0: component simple_filter
    generic map (
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ADDR_WIDTH => 32,
      C_S_AXI_MIN_SIZE => X"000001FF",
      C_USE_WSTRB => 0,
      C_DPHASE_TIMEOUT => 8,
      C_BASEADDR => X"98000000",
      C_HIGHADDR => X"9800FFFF",
      C_FAMILY => "virtex6",
      C_NUM_REG => 1,
      C_NUM_MEM => 1,
      C_SLV_AWIDTH => 32,
      C_SLV_DWIDTH => 32
    )
    port map (
      S_AXI_ACLK => s_axi_aclk,
      S_AXI_ARESETN => peripheral_aresetn(0),
      S_AXI_AWADDR => M05_AXI_awaddr(31 downto 0),
      S_AXI_AWVALID => M05_AXI_awvalid(0),
      S_AXI_WDATA => M05_AXI_wdata,
      S_AXI_WSTRB => M05_AXI_wstrb,
      S_AXI_WVALID => M05_AXI_wvalid(0),
      S_AXI_BREADY => M05_AXI_bready(0), 
      S_AXI_ARADDR => M05_AXI_araddr(31 downto 0),                   
      S_AXI_ARVALID => M05_AXI_arvalid(0),                 
      S_AXI_RREADY => M05_AXI_rready(0),                  
      S_AXI_ARREADY => M05_AXI_arready(0),                 
      S_AXI_RDATA => M05_AXI_rdata,                   
      S_AXI_RRESP => M05_AXI_rresp,                    
      S_AXI_RVALID => M05_AXI_rvalid(0),            
      S_AXI_WREADY => M05_AXI_wready(0),               
      S_AXI_BRESP => M05_AXI_bresp,                    
      S_AXI_BVALID => M05_AXI_bvalid(0),                  
      S_AXI_AWREADY => M05_AXI_awready(0)
    );
 
end STRUCTURE;