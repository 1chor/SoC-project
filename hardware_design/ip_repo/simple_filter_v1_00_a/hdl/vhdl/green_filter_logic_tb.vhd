-------------------------------------------------------------------------------
--
-- green_filter_logic Testbench
--
-------------------------------------------------------------------------------
--

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.green_filter_logic_pkg.all;


--  A testbench has no ports.
entity green_filter_logic_tb is
end green_filter_logic_tb;
--
-------------------------------------------------------------------------------
--
architecture beh of green_filter_logic_tb is

	--  Specifies which entity is bound with the component.
	for green_filter_logic_0: green_filter_logic use entity work.green_filter_logic;	

	constant clk_period : time := 1 ns;
	constant DATA_WIDTH : integer := 32;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
	signal testdata_in		:	std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	signal testdata_out		:	std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
begin
	--  Component instantiation.
	green_filter_logic_0: green_filter_logic
		generic map(
			C_S_AXI_DATA_WIDTH	=> DATA_WIDTH
		)
		port map (
			clk => clk,
			rst => rst,
			regin => testdata_in,
			regout => testdata_out
		);
		
	
		
	Clk_process : process
	
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;

	end process clk_process;	

	--  This process does the real job.
	stimuli : process

	begin

		wait for 10 ns;

		testdata_in <= (others => '0');
		
		wait for 2 ns;
			
		testdata_in <= "00000000000000000000000010000000";
		
		wait for 2 ns;

		testdata_in <= "00000000000000000000000100000000";
		
		wait for 2 ns;
		
        testdata_in <= "00000000000000000100000010000000";
        
        wait for 2 ns;

        testdata_in <= "00000000100000000000000100000000";
               
		wait for 2 ns;
		
		testdata_in <= (others => '1');
		
		wait for 2 ns;
		
		assert false report "end of test" severity note;

		--  Wait forever; this will finish the simulation.
		wait;

	end process stimuli;

end beh;
--
-------------------------------------------------------------------------------
