-------------------------------------------------------------------------------
--
-- blue_filter_logic package
--
-------------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--
-------------------------------------------------------------------------------
--
package filter_logic_pkg is

	component filter_logic is

	  generic(
		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32
	  );
	  port(
	    clk 	    : in std_logic;
	    rst         : in std_logic;
	    regin   	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	    regout   	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0)  
	);
	
	end component filter_logic;
	
end filter_logic_pkg;

