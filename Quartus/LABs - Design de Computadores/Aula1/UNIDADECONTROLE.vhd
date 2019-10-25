library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UNIDADECONTROLE is
	port(
			--======= Entradas UNIDADE de CONTROLE =========
			instrucao : in std_logic_vector(3 downto 0);
			inFlagIgual : in std_logic;
			inFlagCarry : in std_logic;
			--##############################################
			
			--======= Saídas UNIDADE de CONTROLE =========
			OutMuxPC : out std_logic;
			OutMuxInCULA : out std_logic;
			OutWriteEnable : out std_logic
			
			--##############################################			
		);
		
end UNIDADECONTROLE;


architecture arc_UNIDADECONTROLE of UNIDADECONTROLE is

constant MOV 	: std_logic_vector(3 downto 0) := "0000";
constant MOVi 	: std_logic_vector(3 downto 0) := "0001";
constant ADD 	: std_logic_vector(3 downto 0) := "0010";
constant ADDi 	: std_logic_vector(3 downto 0) := "0011";
constant DIV 	: std_logic_vector(3 downto 0) := "0100";
constant DIVi 	: std_logic_vector(3 downto 0) := "0101";
constant CMP 	: std_logic_vector(3 downto 0) := "0110";
constant CMPi 	: std_logic_vector(3 downto 0) := "0111";
constant JE 	: std_logic_vector(3 downto 0) := "1000";
constant JNE 	: std_logic_vector(3 downto 0) := "1001";
constant JC 	: std_logic_vector(3 downto 0) := "0010";
constant STORE : std_logic_vector(3 downto 0) := "1011";
constant WWW 	: std_logic_vector(3 downto 0) := "1100";
constant XXX 	: std_logic_vector(3 downto 0) := "1101";
constant YYY 	: std_logic_vector(3 downto 0) := "1110";
constant ZZZ 	: std_logic_vector(3 downto 0) := "1111";

begin

OutMuxPC	<= 	'1' when (instrucao = JE AND inFlagIgual = '1')	 	OR
								(instrucao = JNE AND inFlagIgual = '0')	OR
								(instrucao = JC AND inFlagCarry = '1')		else
					'0';
					 
OutWriteEnable <=		'0' when (instrucao = JE) OR (instrucao = JNE) OR (instrucao = JC) else
							'1';
	
end arc_UNIDADECONTROLE;