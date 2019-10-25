library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
   port (
          address : in std_logic_vector (11 DOWNTO 0);
          data : out std_logic_vector (15 DOWNTO 0)
    );
end entity;

architecture arc_rom of rom is

  type blocoMemoria is array(0 TO 4095) of std_logic_vector(15 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
        -- Inicializa os endereços:
        tmp(0) := x"AA" & x"AA";
        tmp(1) := x"42" & x"AA";
        tmp(2) := x"43" & x"AA";
        tmp(3) := x"44" & x"AA";
        tmp(4) := x"45" & x"AA";
        tmp(5) := x"46" & x"AA";
        tmp(6) := x"47" & x"AA";
        tmp(7) := x"55" & x"AA";
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    data <= memROM (to_integer(unsigned(address)));
end arc_rom;