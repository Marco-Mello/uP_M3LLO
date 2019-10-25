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
signal sigOutA : std_logic_vector(7 downto 0);
--################################################


--========= Somador / MuxPC / PC / ROM ===========
signal sigAdress : std_logic_vector(11 downto 0);
signal sigOutSomador : std_logic_vector(11 downto 0);
signal sigOutMuxPC : std_logic_vector(11 downto 0);
--################################################


--========= UNIDADE de CONTROLE ===========
signal sigFlagIgual : std_logic;
signal sigFlagCarry : std_logic;
signal sigSELMuxPC : std_logic;
signal sigWriteEnable : std_logic;
signal sigSELMuxInC : std_logic;
--################################################

begin

instrucao <= sigOpcode(15 downto 12);
RA <= sigOpcode(11 downto 8);
RB <= sigOpcode(7 downto 4);
RC <= sigOpcode(3 downto 0);
imediatoDADO <= sigOpcode(7 downto 0);
imediatoJMP <= sigOpcode(11 downto 0);

unidadecontrole : entity work.UNIDADECONTROLE
	port map(
			instrucao => instrucao,
			inFlagIgual => sigFlagIgual,
			inFlagCarry => sigFlagCarry,
			OutMuxInCULA => sigSELMuxInC,
			OutMuxPC => sigSELMuxPC	
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
			inB => sigInB,
			inC => sigOutMuxInCULA,
			instrucao => instrucao,
			outA => sigOutA,
			flagIgual => sigFlagIgual,
			flagCarry => sigFlagCarry
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
	
banco : entity work.BANCO
	port map(
		clk => clk,
		addressB => RB,
		addressC => RC,
		dataB => sigInB,
		dataC => sigInC,
		addressA => RA,
		dataA => sigOutA,
		writeEnable => sigWriteEnable
	);

end arch_CPU;