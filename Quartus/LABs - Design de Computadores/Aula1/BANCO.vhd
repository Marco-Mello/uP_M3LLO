library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco is
	
	port(
		clk : in std_logic;
		
		addressB : in std_logic_vector(3 downto 0);
		addressC : in std_logic_vector(3 downto 0);
		
		dataB : out std_logic_vector(7 downto 0);
		dataC : out std_Logic_vector(7 downto 0);
		
		dataA : in std_logic_vector(7 downto 0);
		addressA : in std_logic_vector(3 downto 0);
		writeEnable : in std_logic := '0'
	);
	
end banco;


architecture arc_banco of banco is

	subtype word_t is std_logic_vector(7 downto 0);
	type memory_t is array(15 downto 0) of word_t;
	
	signal ram : memory_t;


begin
	
	process(clk)
	begin
	if(rising_edge(clk)) then
		if(writeEnable = '1') then
			ram(to_integer(unsigned(addressA))) <= dataA;
		end if;
	end if;
	end process;

	dataB <= ram(to_integer(unsigned(addressB)));
	dataC <= ram(to_integer(unsigned(addressC)));


end arc_banco; 