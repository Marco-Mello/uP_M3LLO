library ieee;
use ieee.std_Logic_1164.all;
use ieee.numeric_std.all;
--use std.textio.all;

entity tb_ULA is end;

architecture arch_tb_ULA of tb_ULA is

signal sigInA : std_logic_vector(7 downto 0);
signal sigInB : std_logic_vector(7 downto 0);
signal sigSel : std_logic_vector(2 downto 0);

begin

ULA1 : entity work.ULA port map(inA => sigInA, inB => sigInB, sel => sigSel, outY => OPEN, overflow => OPEN);

estimulo : process 
begin
	wait for 5 ns; sigInA <= "00000000"; sigInB <= "00001111"; sigSel <= "000";
	wait for 5 ns; sigInA <= "11110000"; sigInB <= "00000000"; sigSel <= "000";
	wait for 5 ns; sigInA <= "10101010"; sigInB <= "11111111"; sigSel <= "000";
	wait;
end process estimulo;

end arch_tb_ULA;