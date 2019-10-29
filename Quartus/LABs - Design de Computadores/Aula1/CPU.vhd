library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY CPU IS
   
   PORT( 
		clk			: in std_logic;
		adress		: out std_logic_vector(7 downto 0);
		dataOut		: out std_logic_vector(7 downto 0);
		dataIn		: in std_logic_vector(7 downto 0);
		readEnable	: out std_logic;
		writeEnable : out std_logic
   );
	
END CPU;


ARCHITECTURE arch_CPU OF CPU IS

--================== PARTICIONAMENTO do OPCODE ===========================
signal sigOpcode : std_logic_vector(15 downto 0);
signal instrucao : std_logic_vector(3 downto 0);
signal RA : std_logic_vector(3 downto 0);
signal RB : std_logic_vector(3 downto 0);
signal RC : std_logic_vector(3 downto 0);
signal imediatoDADO : std_logic_vector(7 downto 0);
signal imediatoJMP : std_logic_vector(11 downto 0);
--#######################################################################

--========= ULA ===========
signal sigInB : std_logic_vector(7 downto 0);
signal sigInC : std_logic_vector(7 downto 0);
signal sigOutMuxInCULA : std_logic_vector(7 downto 0);
signal sigOutMuxInBULA : std_logic_vector(7 downto 0);
signal sigOutULA : std_logic_vector(7 downto 0);
--################################################


--========= Somador / MuxPC / PC / ROM / MUXInBULA  ===========
signal sigAdress : std_logic_vector(11 downto 0);
signal sigOutSomador : std_logic_vector(11 downto 0);
signal sigOutMuxPC : std_logic_vector(11 downto 0);
signal sigOutMuxBANCO : std_logic_vector(7 downto 0);

--################################################



--========= UNIDADE de CONTROLE ===========
signal sigFlagIgual : std_logic;
signal sigFlagCarry : std_logic;
signal sigSELMuxPC : std_logic;
signal sigSELMuxBANCO : std_logic;
signal sigWriteEnable : std_logic;
signal sigSELMuxInC : std_logic;
signal sigSELMuxInB : std_logic;
signal sigSELFuncULA : std_logic_vector(3 downto 0);
signal sigOutRead : std_logic;
signal sigOutWrite : std_logic;
--################################################


--========= EXTERNAL ===========
signal sigDADOin : std_logic_vector(7 downto 0);
--################################################


begin

instrucao <= sigOpcode(15 downto 12);
RA <= sigOpcode(11 downto 8);
RB <= sigOpcode(7 downto 4);
RC <= sigOpcode(3 downto 0);
imediatoDADO <= sigOpcode(7 downto 0);
imediatoJMP <= sigOpcode(11 downto 0);

sigDADOin <= dataIn;
adress <= imediatoDADO;
dataOut <= sigOutULA;
readEnable <= sigOutRead;
writeEnable <= sigOutWrite;

unidadecontrole : entity work.UNIDADECONTROLE
	port map(
			instrucao => instrucao,
			inFlagIgual => sigFlagIgual,
			inFlagCarry => sigFlagCarry,			
			OutMuxPC => sigSELMuxPC,
			OutMuxBanco => sigSELMuxBANCO,
			OutWriteEnableBanco => sigWriteEnable,
			OutMuxInBULA => sigSELMuxInB,
			OutMuxInCULA => sigSELMuxInC,
			OutFuncULA => sigSELFuncULA,
			OutRead => sigOutRead,
			OutWrite => sigOutWrite
	);
	


rom : entity work.ROM
	port map(
			address => sigAdress,
			data => sigOpcode
	);
	
pc : entity work.PC
	port map(
			clk => clk,
			inPC => sigOutMuxPC,
			outPC => sigAdress
	);
	
somador : entity work.SOMADOR
	port map(
			inSOMADOR => sigAdress,
			outSOMADOR => sigOutSomador
	);

muxPC : entity work.MUX2_1
	generic map(
			tamanho_qdtBits => 12
	)
	port map(
			inA => sigOutSomador,
			inB => imediatoJMP,
			sel => sigSELMuxPC,
			outMux => sigOutMuxPC
	);
	
ula : entity work.ULA
	port map(
			inB => sigOutMuxInBULA,
			inC => sigOutMuxInCULA,
			instrucao => sigSELFuncULA,
			outA => sigOutULA,
			flagIgual => sigFlagIgual,
			flagCarry => sigFlagCarry
	);
	
muxInBULA : entity work.MUX2_1
	generic map(
			tamanho_qdtBits => 8
	)
	port map(
			inA => sigDADOin,
			inB => sigInB,
			sel => sigSELMuxInB,
			outMux => sigOutMuxInBULA
	);
	
muxInCULA : entity work.MUX2_1
	generic map(
			tamanho_qdtBits => 8
	)
	port map(
			inA => imediatoDADO,
			inB => sigInC,
			sel => sigSELMuxInC,
			outMux => sigOutMuxInCULA
	);
	
muxBANCO : entity work.MUX2_1
	generic map(
			tamanho_qdtBits => 8
	)
	port map(
			inA => imediatoDADO,
			inB => sigOutULA,
			sel => sigSELMuxBANCO,
			outMux => sigOutMuxBANCO
	);
	
banco : entity work.BANCO
	port map(
		clk => clk,
		addressB => RB,
		addressC => RC,
		dataB => sigInB,
		dataC => sigInC,
		addressA => RA,
		dataA => sigOutMuxBANCO,
		writeEnable => sigWriteEnable
	);

end arch_CPU;