
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
	
	port(
		inA : in std_logic_vector(7 downto 0);
		inB : in std_logic_vector(7 downto 0);
		sel : in std_logic_vector(2 downto 0);
		outY : out std_logic_vector(7 downto 0);
		overflow : out std_logic
	);
	
end ula;


architecture arc_ula of ula is

signal sigOVERFLOW : std_logic_vector(8 downto 0);

begin
	
	outY <= std_logic_vector(to_unsigned( to_integer(unsigned(inA)) + to_integer(unsigned(inB)) , 8)) when sel = "000" else "ZZZZZZZZ";
	
	sigOVERFLOW <= std_logic_vector(to_unsigned( to_integer(unsigned('0' & inA)) + to_integer(unsigned('0' & inB)) , 9)) when sel = "000" else "ZZZZZZZZZ";
	overflow <= sigOVERFLOW(8);

end arc_ula; 