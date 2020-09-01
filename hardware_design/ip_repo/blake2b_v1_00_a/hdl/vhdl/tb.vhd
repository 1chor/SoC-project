library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture behav of tb is

	component user_logic is
		generic
		(
			-- ADD USER GENERICS BELOW THIS LINE ---------------
			--USER generics added here
			-- ADD USER GENERICS ABOVE THIS LINE ---------------

			-- DO NOT EDIT BELOW THIS LINE ---------------------
			-- Bus protocol parameters, do not add to or delete
			C_NUM_REG                      : integer              := 4;
			C_SLV_DWIDTH                   : integer              := 32
			-- DO NOT EDIT ABOVE THIS LINE ---------------------
		);
		port (
			-- ADD USER PORTS BELOW THIS LINE ------------------
			--USER ports added here
			Interrupt : out std_logic;
			-- ADD USER PORTS ABOVE THIS LINE ------------------

			-- DO NOT EDIT BELOW THIS LINE ---------------------
			-- Bus protocol ports, do not add to or delete
			Bus2IP_Clk                     : in  std_logic;
			Bus2IP_Resetn                  : in  std_logic;
			Bus2IP_Data                    : in  std_logic_vector(32-1 downto 0);
			Bus2IP_BE                      : in  std_logic_vector(32/8-1 downto 0);
			Bus2IP_RdCE                    : in  std_logic_vector(4-1 downto 0);
			Bus2IP_WrCE                    : in  std_logic_vector(4-1 downto 0);
			IP2Bus_Data                    : out std_logic_vector(32-1 downto 0);
			IP2Bus_RdAck                   : out std_logic;
			IP2Bus_WrAck                   : out std_logic;
			IP2Bus_Error                   : out std_logic
			-- DO NOT EDIT ABOVE THIS LINE ---------------------
		);

	end component;

	signal Interrupt                      : std_logic;
	signal Bus2IP_Clk                     : std_logic;
	signal Bus2IP_Resetn                  : std_logic;
	signal Bus2IP_Data                    : std_logic_vector(32-1 downto 0);
	signal Bus2IP_BE                      : std_logic_vector(32/8-1 downto 0);
	signal Bus2IP_RdCE                    : std_logic_vector(4-1 downto 0);
	signal Bus2IP_WrCE                    : std_logic_vector(4-1 downto 0);
	signal IP2Bus_Data                    : std_logic_vector(32-1 downto 0);
	signal IP2Bus_RdAck                   : std_logic;
	signal IP2Bus_WrAck                   : std_logic;
	signal IP2Bus_Error                   : std_logic;

	constant period : time := 10 ns;
	signal   ended  : std_logic := '0';

	constant message_len : integer := 7;

begin

	dut : user_logic

	port map (
		Interrupt		=>	Interrupt,
		Bus2IP_Clk		=>	Bus2IP_Clk,
		Bus2IP_Resetn	=>	Bus2IP_Resetn,
		Bus2IP_Data		=>	Bus2IP_Data,
		Bus2IP_BE		=>	Bus2IP_BE,
		Bus2IP_RdCE		=>	Bus2IP_RdCE,
		Bus2IP_WrCE		=>	Bus2IP_WrCE,
		IP2Bus_Data		=>	IP2Bus_Data,
		IP2Bus_RdAck	=>	IP2Bus_RdAck,
		IP2Bus_WrAck	=>	IP2Bus_WrAck,
		IP2Bus_Error	=>	IP2Bus_Error
	);


	clk_process: process

	begin

		Bus2IP_Clk <= '0';
		wait for period/2;
		Bus2IP_Clk <= '1';
		wait for period/2;

		if ended = '1' then
			wait;
		end if;

	end process;


	stimuli : process

	begin

		Bus2IP_Resetn <= '0';
		wait for 10 ns;
		Bus2IP_Resetn <= '1';
		wait for 50 ns;
		
		Bus2IP_WrCE <= "1000";
		Bus2IP_BE <= "1111";
		Bus2IP_Data <= std_logic_vector(to_unsigned(message_len, Bus2IP_Data'length));
		wait for period;
		Bus2IP_WrCE <= "0000";
		
		--for i in 0 to message_len/4-1 loop
		--	wait until Interrupt = '1';
		--	Bus2IP_WrCE <= "0100";
		--	Bus2IP_BE <= "1111";
		--	Bus2IP_Data <= std_logic_vector(to_unsigned(i, Bus2IP_Data'length));
		--	wait for period;
		--	Bus2IP_WrCE <= "0000";
		--end loop;
		--Bus2IP_Data <= X"00000000";
		
		
		wait until Interrupt = '1';
		Bus2IP_WrCE <= "0100";
		Bus2IP_BE <= "1111";
		Bus2IP_Data <= X"4d657373";
		wait for period;
		Bus2IP_WrCE <= "0000";
		
		wait until Interrupt = '1';
		Bus2IP_WrCE <= "0100";
		Bus2IP_BE <= "1111";
		Bus2IP_Data <= X"61676500";
		wait for period;
		Bus2IP_WrCE <= "0000";
		
		wait until Interrupt = '1';
			
		Bus2IP_RdCE <= "0001";
			
		for i in 15 downto 0 loop
			Bus2IP_WrCE <= "0001";
			Bus2IP_BE <= "1111";
			Bus2IP_Data <= std_logic_vector(to_unsigned(i,32));
			wait for period;
			Bus2IP_WrCE <= "0000";
			wait for period;
			
		end loop;
	
		wait for period*10000;

		ended <= '1';

		wait;

	end process;

end behav;