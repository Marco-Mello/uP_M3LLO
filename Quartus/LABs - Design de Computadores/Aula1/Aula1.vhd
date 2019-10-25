library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY Aula1 IS
   
   PORT( 
		rst		: IN std_logic;
      clock_50	: IN std_logic;
		 
      lcd_rs	: OUT	std_logic;
      lcd_en	: OUT	std_logic;
      lcd_rw	: OUT	std_logic;
      lcd_on	: OUT	std_logic;
      lcd_blon	: OUT	std_logic;
		
		lcd_data : INOUT STD_LOGIC_VECTOR (7 downto 0);
		pc  : IN STD_LOGIC_VECTOR (7 downto 0);	
		opcode : IN STD_LOGIC_VECTOR (19 downto 0);	

		sw : IN STD_LOGIC_VECTOR(17 DOWNTO 0)
      
   );
	
END Aula1;


ARCHITECTURE arch_Aula1 OF Aula1 IS

signal sw_to_opcode : std_logic_vector (19 downto 0);

begin

sw_to_opcode <= "00" & sw(17 downto 0);

lcd : entity work.lcd
	port map(
		RST => RST,
      CLOCK_50 => CLOCK_50,
		LCD_RS => LCD_RS,
		LCD_EN => LCD_EN,
      LCD_RW => LCD_RW,
		LCD_ON => LCD_ON,
		LCD_BLON => LCD_BLON,
		LCD_DATA => LCD_DATA,
		PC => PC,
		OPCODE => sw_to_opcode
	);

end arch_Aula1;