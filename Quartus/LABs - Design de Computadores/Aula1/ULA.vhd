library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
	
	port(
		inB : in std_logic_vector(7 downto 0);
		inC : in std_logic_vector(7 downto 0);
		instrucao : in std_logic_vector(3 downto 0);
		outA : out std_logic_vector(7 downto 0);
		flagIgual : out std_logic;
		flagCarry : out std_logic
	);
	
end ula;


architecture arc_ula of ula is

signal sigflagCarry : std_logic_vector(8 downto 0);

constant MOV 			: std_logic_vector(3 downto 0) := "0000";
constant MOVi 			: std_logic_vector(3 downto 0) := "0001";
constant ADD 			: std_logic_vector(3 downto 0) := "0010";
constant ADDi 			: std_logic_vector(3 downto 0) := "0011";
constant DIV 			: std_logic_vector(3 downto 0) := "0100";
constant DIVi 			: std_logic_vector(3 downto 0) := "0101";
constant CMP, SUB 	: std_logic_vector(3 downto 0) := "0110";
constant CMPi, SUBi 	: std_logic_vector(3 downto 0) := "0111";
constant JE 			: std_logic_vector(3 downto 0) := "1000";
constant JNE 			: std_logic_vector(3 downto 0) := "1001";
constant JC 			: std_logic_vector(3 downto 0) := "0010";
constant JMP 			: std_logic_vector(3 downto 0) := "1011";
constant STORE 		: std_logic_vector(3 downto 0) := "1100";
constant LOAD 			: std_logic_vector(3 downto 0) := "1101";
constant YYY 			: std_logic_vector(3 downto 0) := "1110";
constant ZZZ 			: std_logic_vector(3 downto 0) := "1111";

begin

	sigflagCarry <= std_logic_vector(to_unsigned( to_integer(unsigned('0' & inB)) + to_integer(unsigned('0' & inC)) , 9)) when (instrucao = ADD) OR (instrucao = ADDi) else
				"ZZZZZZZZZ";
	flagCarry <= sigflagCarry(8);
	
	flagIgual <= '1' when inB = inC else '0';
	
	outA <= 	std_logic_vector(to_unsigned( to_integer(unsigned(inB)) + to_integer(unsigned(inC)) , 8)) when (instrucao = ADD) OR (instrucao = ADDi)	else
				"ZZZZZZZZ";
				
	
			
		
	

end arc_ula; 