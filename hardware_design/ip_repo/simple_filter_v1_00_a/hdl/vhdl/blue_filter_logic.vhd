library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity filter_logic is
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
end filter_logic;

architecture IMP of filter_logic is
begin
  process (regin)
  variable temp : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
  begin
    for k in 0 to (C_S_AXI_DATA_WIDTH - 1) loop
        if k < 8 then
            temp(k) := regin(k);
        else
            temp(k) := '0';
        end if;
    end loop;
    regout <= temp;
  end process;
end IMP;
