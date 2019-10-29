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
			OutMuxBanco : out std_logic;
			OutWriteEnableBanco : out std_logic;
			OutMuxInBULA : out std_logic;
			OutMuxInCULA : out std_logic;
			OutFuncULA : out std_logic_vector(3 downto 0);
			OutRead : out std_logic;
			OutWrite: out std_logic
			--##############################################			
		);
		
end UNIDADECONTROLE;


architecture arc_UNIDADECONTROLE of UNIDADECONTROLE is

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

OutMuxPC	<= 	'1' when (instrucao = JE AND inFlagIgual = '1')		OR
								(instrucao = JNE AND inFlagIgual = '0')	OR
								(instrucao = JC AND inFlagCarry = '1')		OR
								(instrucao = JMP)	else
					'0';
	
					
OutWriteEnableBanco <= 	'0' when (instrucao = JE AND inFlagIgual = '1')		OR
								(instrucao = JNE AND inFlagIgual = '0')	OR
								(instrucao = JC AND inFlagCarry = '1')		OR
								(instrucao = JMP) OR
								(instrucao = STORE)		else
					'1';
					
OutMuxBANCO	<= 	'1' when (instrucao = MOVi)	OR
								(instrucao = ADDi)	OR
								(instrucao = DIVi)	OR
								(instrucao = CMPi) OR
								(instrucao = SUBi)	else
					'0';
					
OutMuxInBULA	<= 	'1' when (instrucao = MOV)	OR
								(instrucao = ADD)	OR
								(instrucao = ADDi)	OR
								(instrucao = DIV)	OR
								(instrucao = DIVi)	OR
								(instrucao = CMP) OR
								(instrucao = CMPi) OR
								(instrucao = SUB) OR
								(instrucao = SUBi)	else
					'0';
					
OutMuxInCULA	<= 	'1' when (instrucao = ADD)	OR
								(instrucao = DIV)	OR
								(instrucao = CMP) OR
								(instrucao = SUB) else
					'0';
					
OutFuncULA <= instrucao;

OutWrite <= '1' when (instrucao = STORE) else '0';

OutRead <= '1' when (instrucao = LOAD) else '0';
					
end arc_UNIDADECONTROLE;