library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX2_1 is
	generic(
			tamanho_qdtBits : natural := 12
	);
	
	port(
			inA : in std_logic_vector(tamanho_qdtBits-1 downto 0);
			inB : in std_logic_vector(tamanho_qdtBits-1 downto 0);
			sel : in std_logic;
			outMux : out std_logic_vector(tamanho_qdtBits-1 downto 0)			
		);
		
end MUX2_1;

architecture arc_MUX2_1 of MUX2_1 is
begin

outMux	<= 	inA when sel = '0' else
					inB when sel = '1' else (others=>'Z'); 
	
end arc_MUX2_1;