-------------------------------------------------------------------------------
--
-- blue_filter_logic Testbench
--
-------------------------------------------------------------------------------
--

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--  A testbench has no ports.
entity blue_filter_logic_tb is
end blue_filter_logic_tb;
--
-------------------------------------------------------------------------------
--

architecture beh of blue_filter_logic_tb is

	--  Specifies which entity is bound with the component.
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

	constant clk_period : time := 1 ns;
	constant DATA_WIDTH : integer := 32;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
	signal testdata_in		:	std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	signal testdata_out		:	std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	signal   ended  : std_logic := '0';
begin
	--  Component instantiation.
	blue_filter_logic_0: filter_logic
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
		
		if ended = '1' then
			wait;
		end if;

	end process clk_process;	

	--  This process does the real job.
	stimuli : process

	begin
		
		rst <= '1';
		wait for 10 ns;
		rst <= '0';
		wait for 50 ns;

		testdata_in <= (others => '0');
		
		wait for 2 ns;
			
		testdata_in <= "00000000000000000000000011111111";
		
		wait for 2 ns;

		testdata_in <= "00000000000000000000000100000000";
		
		wait for 2 ns;
		
		testdata_in <= (others => '1');
		
		wait for 2 ns;
		
		--  Wait forever; this will finish the simulation.
		ended <= '1';
		wait;

	end process stimuli;

end beh;
--
-------------------------------------------------------------------------------
