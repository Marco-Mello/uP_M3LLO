library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somador is
	
	port(
			inSOMADOR : in std_logic_vector(11 downto 0);
			outSOMADOR : out std_logic_vector(11 downto 0)
			
		);
		
end somador;

architecture arc_somador of somador is
begin

			outSOMADOR <= std_logic_vector(to_unsigned((to_integer(unsigned(inSOMADOR)) + 1), 12));	

end arc_somador;