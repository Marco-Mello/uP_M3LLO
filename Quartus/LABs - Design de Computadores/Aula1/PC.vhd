library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
	
	port(
			clk : in std_logic;
			inPC : in std_logic_vector(11 downto 0);
			outPC : out std_logic_vector(11 downto 0)			
		);
		
end pc;

architecture arc_pc of pc is
begin

	process(clk)
	begin
		if(rising_edge(clk)) then
			outPC <= inPC;	
		end if;
	end process;
	
end arc_pc;