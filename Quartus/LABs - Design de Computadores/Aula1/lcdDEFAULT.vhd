-- VHDL CODE by Gerry O'Brien - HD44780 LCD Controller STATE_MACHINE
--==================================================--
--
-- VHDL Architecture DE2_LCD_lib.LCD_DISPLAY_nty.LCD_DISPLAY_arch
--
-- Created:
--          by - Gerry O'Brien 
--          WWW.DIGITAL-CIRCUITRY.COM
--          at - 16:10:23 23/07/2016
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
use  ieee.numeric_std.all;


ENTITY lcd IS
   
   PORT( 
		
      CLOCK_50           : IN     std_logic;-- to drive the LCD CORE state machine.
		
		PC  : IN STD_LOGIC_VECTOR (7 downto 0);	
		OPCODE : IN STD_LOGIC_VECTOR (19 downto 0);
		RST : IN std_logic;
		 
      LCD_RS             : OUT    std_logic;
      LCD_EN              : OUT    std_logic;
      LCD_RW            : OUT    std_logic;
      LCD_ON            : OUT    std_logic;
      LCD_BLON           : OUT    std_logic;
		LCD_DATA : INOUT STD_LOGIC_VECTOR (7 downto 0)     
      
   );

-- Declarations

END lcd ;

--
ARCHITECTURE LCD_DISPLAY_arch OF lcd IS
  type character_string is array ( 0 to 31 ) of STD_LOGIC_VECTOR( 7 downto 0 );
  
  type state_type is (func_set, display_on, mode_set, print_string,
                      line2, return_home, drop_lcd_e, reset1, reset2,
                       reset3, display_off, display_clear );
                       
  signal state, next_command         : state_type;
  
  signal sigOPCODE : STD_LOGIC_VECTOR (19 downto 0);
  signal sigPC : STD_LOGIC_VECTOR( 7 downto 0 );
  
  
  signal lcd_display_char : character_string := ( x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20",x"20",
							 x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20",x"20");
  
  signal data_bus_value, next_char   : STD_LOGIC_VECTOR(7 downto 0);
  signal clk_count_400hz             : STD_LOGIC_VECTOR(23 downto 0);
  signal char_count                  : STD_LOGIC_VECTOR(4 downto 0);
  signal clk_400hz_enable,lcd_rw_int : std_logic;
  
  --signal Hex_Display_Data            : STD_LOGIC_VECTOR(7 DOWNTO 0); 
  signal data_bus                    : STD_LOGIC_VECTOR(7 downto 0);	
 -- signal LCD_CHAR_ARRAY              : STD_LOGIC_VECTOR(3 DOWNTO 0);
  
--  
--  signal sigPC0 : integer;
--  signal sigPC1 : integer;
--  signal sigPC2 : integer;
  
  signal sigPC0_print : STD_LOGIC_VECTOR( 7 downto 0 );
  signal sigPC1_print : STD_LOGIC_VECTOR( 7 downto 0 );
  signal sigPC2_print : STD_LOGIC_VECTOR( 7 downto 0 );
  
  
--  signal  regA0 : integer;
--  signal  regA1 : integer;
--  signal  Imedi0 : integer;
--  signal  Imedi1 : integer;
--  signal  Imedi2 : integer;
  
  signal  regA0_print : STD_LOGIC_VECTOR( 7 downto 0 );
  signal  regA1_print : STD_LOGIC_VECTOR( 7 downto 0 );
  signal  regA2_print : STD_LOGIC_VECTOR( 7 downto 0 );
  signal  Imedi0_print : STD_LOGIC_VECTOR( 7 downto 0 );
  signal  Imedi1_print : STD_LOGIC_VECTOR( 7 downto 0 );
  signal  Imedi2_print : STD_LOGIC_VECTOR( 7 downto 0 );
  
  constant MOV : STD_LOGIC_VECTOR(3 downto 0) := "0000";
  constant CMP : STD_LOGIC_VECTOR(3 downto 0) := "0001";
  constant JE : STD_LOGIC_VECTOR(3 downto 0) := "0010";
  constant ADD : STD_LOGIC_VECTOR(3 downto 0) := "0011";

BEGIN
  
--LEDR <= SW;
sigOPCODE <= OPCODE;
sigPC <= PC;
--===================================================--  
-- SIGNAL STD_LOGIC_VECTORS assigned to OUTPUT PORTS 
--===================================================--    
LCD_DATA(0) <= data_bus(0);
LCD_DATA(1) <= data_bus(1);
LCD_DATA(2) <= data_bus(2);
LCD_DATA(3)	<= data_bus(3);
LCD_DATA(4)	<= data_bus(4);
LCD_DATA(5) <= data_bus(5);
LCD_DATA(6)	<= data_bus(6);
LCD_DATA(7) <= data_bus(7);

--=====================================--


  

--===============================-- 
--  HD44780 CHAR DATA HEX VALUES --
--===============================-- 
--   = x"20", 
-- ! = x"21",
-- " = x"22",
-- # = x"23",
-- $ = x"24",
-- % = x"25",
-- & = x"26",
-- ' = x"27",
-- ( = x"28",
-- ) = x"29",
-- * = x"2A",
-- + = x"2B",
-- , = x"2C",
-- - = x"2D",
-- . = x"2E",
-- / = x"2F",




-- 1 = x"31",
-- 2 = x"32",
-- 3 = x"33",
-- 4 = x"34",
-- 5 = x"35",
-- 6 = x"36",
-- 7 = x"37",
-- 8 = x"38",
-- 9 = x"39",
-- : = x"3A",
-- ; = x"3B",
-- < = x"3C",
-- = = x"3D",
-- > = x"3E",
-- ? = x"3F",




-- Q = x"40",
-- A = x"41",
-- B = x"42",
-- C = x"43",
-- D = x"44",
-- E = x"45",
-- F = x"46",
-- G = x"47",
-- H = x"48",
-- I = x"49",
-- J = x"4A",
-- K = x"4B",
-- L = x"4C",
-- M = x"4D",
-- N = x"4E",
-- O = x"4F",



-- P = x"50",
-- Q = x"51",
-- R = x"52",
-- S = x"53",
-- T = x"54",
-- U = x"55",
-- V = x"56",
-- W = x"57",
-- X = x"58",
-- Y = x"59",
-- Z = x"5A",
-- [ = x"5B",
-- Y! = x"5C",
-- ] = x"5D",
-- ^ = x"5E",
-- _ = x"5F",



-- \ = x"60",
-- a = x"61",
-- b = x"62",
-- c = x"63",
-- d = x"64",
-- e = x"65",
-- f = x"66",
-- g = x"67",
-- h = x"68",
-- i = x"69",
-- j = x"6A",
-- k = x"6B",
-- l = x"6C",
-- m = x"6D",
-- n = x"6E",
-- o = x"6F",



-- p = x"70",
-- q = x"71",
-- r = x"72",
-- s = x"73",
-- t = x"74",
-- u = x"75",
-- v = x"76",
-- w = x"77",
-- x = x"78",
-- y = x"79",
-- z = x"7A",
-- { = x"7B",
-- | = x"7C",
-- } = x"7D",
-- -> = x"7E",
-- <- = x"7F",



-------------------------------------------------------------------------------------------------------
-- BIDIRECTIONAL TRI STATE LCD DATA BUS
   data_bus <= data_bus_value when lcd_rw_int = '0' else "ZZZZZZZZ";
   
-- LCD_RW PORT is assigned to it matching SIGNAL 
	LCD_RW <= lcd_rw_int;
	
 
 
 
 
 
 
 
 

 
 
 

------------------------------------ STATE MACHINE FOR LCD SCREEN MESSAGE SELECT -----------------------------
---------------------------------------------------------------------------------------------------------------
PROCESS (OPCODE, sigPC)
BEGIN

--==========================================================================================	
--================================== Printa PC =============================================
--==========================================================================================	

	sigPC0_print <= std_logic_vector(to_unsigned((to_integer(unsigned(PC(7 downto 0))) / 100)  + 48, 8));
	sigPC1_print <= std_logic_vector(to_unsigned(((to_integer(unsigned(PC (7 downto 0)))rem 100) / 10) + 48, 8));
	sigPC2_print <= std_logic_vector(to_unsigned(((to_integer(unsigned(PC (7 downto 0)))rem 100)rem 10) + 48, 8));
	lcd_display_char(0 to 7) <= (x"50", x"43", x"20", x"3E", x"20", sigPC0_print, sigPC1_print, sigPC2_print);
	
--##########################################################################################
--##########################################################################################
--##########################################################################################			
			
			
--===================================================================================================	
--================================== Printa Registrador/IMEDIATO ====================================
--===================================================================================================

	if( OPCODE(7 downto 0) >= "00000000" AND OPCODE(19 downto 16) = JE) then --Printa imediato
	
	regA0_print <= std_logic_vector(to_unsigned((to_integer(unsigned(OPCODE(7 downto 0))) / 100)  + 48, 8));
	regA1_print <= std_logic_vector(to_unsigned(((to_integer(unsigned(OPCODE(7 downto 0)))rem 100) / 10) + 48, 8));
	regA2_print <= std_logic_vector(to_unsigned(((to_integer(unsigned(OPCODE(7 downto 0)))rem 100)rem 10) + 48, 8));
	
	lcd_display_char(4+16 to 6+16) <= ( regA0_print, regA1_print, regA2_print);
	lcd_display_char(7+16 to 10+16) <= ( x"20", x"20",  x"20",  x"20");
	
	elsif( OPCODE(15 downto 8) >= "00000000") then --Printa registrador

	regA0_print <= std_logic_vector(to_unsigned((to_integer(unsigned(OPCODE(15 downto 8))) / 100)  + 48, 8));
	regA1_print <= std_logic_vector(to_unsigned(((to_integer(unsigned(OPCODE(15 downto 8)))rem 100) / 10) + 48, 8));
	regA2_print <= std_logic_vector(to_unsigned(((to_integer(unsigned(OPCODE(15 downto 8)))rem 100)rem 10) + 48, 8));
	
	lcd_display_char(5+16 to 7+16) <= ( regA0_print, regA1_print, regA2_print);
	lcd_display_char(8+16 to 10+16) <= ( x"2C", x"20",  x"23");
			
	 END IF;
--##########################################################################################
--##########################################################################################
--##########################################################################################		 

	
		
		 
	if( (OPCODE(7 downto 0) >= "00000000") AND (OPCODE(19 downto 16) /= JE) ) then
	
		imedi0_print <= std_logic_vector(to_unsigned((to_integer(unsigned(OPCODE(7 downto 0)))/100) + 48, 8));
		imedi1_print <= std_logic_vector(to_unsigned(((to_integer(unsigned( OPCODE(7 downto 0)))rem 100)/10) + 48, 8));
		imedi2_print <= std_logic_vector(to_unsigned(((to_integer(unsigned(OPCODE(7 downto 0)))rem 100)rem 10) + 48, 8));
		
		lcd_display_char(11+16 to 13+16) <= ( imedi0_print, imedi1_print, imedi2_print);
	else
		lcd_display_char(11+16 to 13+16) <= ( x"20", x"20", x"20");	
	 END IF;	
	 
	 
	 
	 if( OPCODE(19 downto 16) = MOV ) then
			lcd_display_char(0+16 to 3+16) <= ( x"4D", x"4F", x"56", x"20"); 	 --MOV
			lcd_display_char(4+16) <= ( x"52" );										 --MOV
			
	elsif( OPCODE(19 downto 16) = CMP ) then
			lcd_display_char(0+16 to 3+16) <= ( x"43", x"4D", x"50", x"20"); 	 --CMP
			lcd_display_char(4+16) <= ( x"52" );										 --CMP
			
	elsif( OPCODE(19 downto 16) = JE ) then
			lcd_display_char(0+16 to 3+16) <= ( x"4A", x"45", x"20", x"23"); 	 --JE
			
	elsif( OPCODE(19 downto 16) = ADD ) then
			lcd_display_char(0+16 to 3+16) <= ( x"41", x"44", x"44", x"20"); 	 --ADD
			lcd_display_char(4+16) <= ( x"52" );										 --ADD
			
	else
			lcd_display_char(0 to 31) <= (x"50", x"43", x"20", x"3E", x"20", sigPC0_print, sigPC1_print, sigPC2_print,  x"20", x"20", x"20",x"20",
			x"20", x"20", x"20", x"20", x"4E", x"4F", x"50", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20"); --NOP
	 END IF;		
			
			
			
	 
	 
               next_char <= lcd_display_char(to_integer(unsigned(char_count)));
END PROCESS;
   

 
  
  
  
--======================= CLOCK SIGNALS ============================--  
process(clock_50)
begin
      if (rising_edge(clock_50)) then
         if (RST = '0') then
            clk_count_400hz <= x"000000";
            clk_400hz_enable <= '0';
         else
           
           
--== NOTE for the IF statement below:
----------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
-- Due to the fact that each STATE in the LCD Driver State Machine... (Shown further below) ...each state will immediately be followed by the "drop_lcd_e" STATE....
-- this will cause the Period of the "lcd_e" signal to be doubled when viewed on an Oscilloscope. This also causes your set frequency value 
-- to be divided in half. The variable "clk_count_400hz" whichever hex value you choose for a specific Frequency, that frequency will be divided in half.  
-- i.e: (clk_count_400hz <= x"7A120") is the value for a 100hz signal, however when you monitor the LCD's "ENABLE" port with an oscilloscope; it will be detected as 
-- a 50Hz signal. (Half the Set Frequency). This is becasue the State machine cycles twice!!! Creating 1 Full Cycle for the "LCD_E" Port. Logic HI...then....LOGIC LOW.
--======================================================================================================================================================================             
           
          if (clk_count_400hz <= x"00F424") then            
                                                 -- If using the DE2 50Mhz Clock,  use clk_count_1600hz <= x"007A12"  (50Mhz/1600hz = 32250   converted to HEX = 7A12 )
                                                 --                                use clk_count_1250hz <= x"009C40"  (50Mhz/1250hz = 40000   converted to HEX = 9C40 )
                                                 --                                use clk_count_800hz  <= x"00F424"  (50Mhz/800hz  = 62500   converted to HEX = F424 )
                                                 --                                use clk_count_400hz  <= x"01E848"  (50Mhz/400hz  = 125000  converted to HEX = 1E848 )
                                                 --                                use clk_count_200hz  <= x"03D090"  (50Mhz/200hz  = 250000  converted to HEX = 3D090 )
                                                 --                                use clk_count_100hz  <= x"07A120"  (50Mhz/100hz  = 500000  converted to HEX = 7A120 )
                                                 --                                use clk_count_50hz   <= x"0F4240"  (50Mhz/50hz   = 1000000 converted to HEX = F4240 )
                                                 --                                use clk_count_10hz   <= x"4C4B40"  (50Mhz/10hz   = 5000000 converted to HEX = 4C4B40 )
                                                           
                                                 --  In Theory for a 27Mhz Clock,  use clk_count_400hz <= x"107AC"  (27Mhz/400hz = 67500  converted to HEX = 107AC )
                                                 --                                use clk_count_200hz <= x"20F58"  (27Mhz/200hz = 125000 converted to HEX = 20F58 )
                                                             
                                                 --  In Theory for a 25Mhz Clock.  use clk_count_400hz <= x"00F424"  (25Mhz/400hz = 62500  converted to HEX = F424 )
                                                 --                                use clk_count_200hz <= x"01E848"  (25Mhz/200hz = 125000 converted to HEX = 1E848 )
                                                 --                                use clk_count_100hz <= x"03D090"  (25Mhz/100hz = 250000 converted to HEX = 3D090 )
                                                           
                                                           
                   clk_count_400hz <= std_logic_vector(to_unsigned(to_integer(unsigned(clk_count_400hz)) + 1, 24));                                          
                   clk_400hz_enable <= '0';                
           else
                   clk_count_400hz <= x"000000";
                   clk_400hz_enable <= '1';
            end if;
         end if;
      end if;
end process;  
--==================================================================--    
  
  
  
  
--======================== LCD DRIVER CORE ==============================--   
--                     STATE MACHINE WITH RESET                          -- 
--===================================================-----===============--  
process (clock_50, RST)
begin
        if RST = '0' then
           state <= reset1;
           data_bus_value <= x"38"; -- RESET
           next_command <= reset2;
           LCD_EN<= '1';
           LCD_RS <= '0';
           lcd_rw_int <= '0';  
    
    
    
        elsif rising_edge(clock_50) then
             if clk_400hz_enable = '1' then  
                 
                 
                 
              --========================================================--                 
              -- State Machine to send commands and data to LCD DISPLAY
              --========================================================--
                 case state is
                 -- Set Function to 8-bit transfer and 2 line display with 5x8 Font size
                 -- see Hitachi HD44780 family data sheet for LCD command and timing details
                       
                       
                       
--======================= INITIALIZATION START ============================--
                       when reset1 =>
                            LCD_EN <= '1';
                            LCD_RS <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"38"; -- EXTERNAL RESET
                            state <= drop_lcd_e;
                            next_command <= reset2;
                            char_count <= "00000";
  
                       when reset2 =>
                            LCD_EN <= '1';
                            LCD_RS<= '0';
                            lcd_rw_int  <= '0';
                            data_bus_value <= x"38"; -- EXTERNAL RESET
                            state <= drop_lcd_e;
                            next_command <= reset3;
                            
                       when reset3 =>
                            LCD_EN <= '1';
                            LCD_RS <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"38"; -- EXTERNAL RESET
                            state <= drop_lcd_e;
                            next_command <= func_set;
            
            
                       -- Function Set
                       --==============--
                       when func_set =>                
                            LCD_EN <= '1';
                            LCD_RS <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"38";  -- Set Function to 8-bit transfer, 2 line display and a 5x8 Font size
                            state <= drop_lcd_e;
                            next_command <= display_off;
                            
                            
                            
                       -- Turn off Display
                       --==============-- 
                       when display_off =>
                            LCD_EN <= '1';
                            LCD_RS <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"08"; -- Turns OFF the Display, Cursor OFF and Blinking Cursor Position OFF.......
                                                     -- (0F = Display ON and Cursor ON, Blinking cursor position ON)
                            state <= drop_lcd_e;
                            next_command <= display_clear;
                           
                           
                       -- Clear Display 
                       --==============--
                       when display_clear =>
                            LCD_EN <= '1';
                            LCD_RS <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"01"; -- Clears the Display    
                            state <= drop_lcd_e;
                            next_command <= display_on;
                           
                           
                           
                       -- Turn on Display and Turn off cursor
                       --===================================--
                       when display_on =>
                            LCD_EN <= '1';
                            LCD_RS <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"0C"; -- Turns on the Display (0E = Display ON, Cursor ON and Blinking cursor OFF) 
                            state <= drop_lcd_e;
                            next_command <= mode_set;
                          
                          
                       -- Set write mode to auto increment address and move cursor to the right
                       --====================================================================--
                       when mode_set =>
                            LCD_EN <= '1';
                            LCD_RS <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"06"; -- Auto increment address and move cursor to the right
                            state <= drop_lcd_e;
                            next_command <= print_string; 
                            
                                
--======================= INITIALIZATION END ============================--                          
                          
                          
                          
                          
--=======================================================================--                           
--               Write ASCII hex character Data to the LCD
--=======================================================================--
                       when print_string =>          
                            state <= drop_lcd_e;
                            LCD_EN <= '1';
                            LCD_RS <= '1';
                            lcd_rw_int <= '0';
                          
                          
                               -- ASCII character to output
                               -----------------------------
                               -- Below we check to see if the Upper-Byte of the HEX number being displayed is x"0"....We use this number x"0" as a Control Variable, 
                               -- to know when a certain condition is met.  Next, we proceed to process the "next_char" variable to Sequentially count up in HEX format.
                               
                               -- This is required because as you know...Counting in HEX...after #9 comes Letter A.... well if you look at the ASCII CHART, 
                               -- the Letters A,B,C etc. are in a different COLUMN compared to the one the Decimal Numbers are in.  Letters A...F are in Column  x"4".    
                               -- Numbers 0...9 are in Column x"3".  The Upper-Byte controls which COLUMN the Character will be selected from... and then Displayed on the LCD. 
                               
                               -- So to Count up seamlessly using our 4-Bit Variable 8,9,10,11 and so on...we need to set some IF THEN ELSE conditions 
                               -- to control this changing of Columns so that it will be displayed counting up in HEX Format....8,9,A,B,C,D etc.
                                
                               -- Also, if the High-Byte is detected as an actual Character Column from the ASCII CHART that has Valid Characters 
                               -- (Like using a Upper-Byte of x"2",x"3",x"4",x"5",x"6" or x"7") then it will just go ahead and decalre  "data_bus_value <= next_char;"  
                               -- and the "Print_Sring" sequence will continue to execute. These HEX Counting conditions are only being applied to the Variables that have 
                               -- the x"0" Upper-Byte value.....For our code that is the:  [x"0"&hex_display_data]  variable.  
                               
                               
                               if (next_char(7 downto 4) /= x"0") then
                                  data_bus_value <= next_char;
                               else
                             
                                    -- Below we process a 4-bit STD_LOGIC_VECTOR that is counting up Sequentially, we process the values so that it Displays in HEX Format as it counts up.
                                    -- In our case, our SWITCHES have been Mapped to a 4-bit STD_LOGIC_VECTOR and we have placed an Upper-Byte value of x"0" before it.
                                    -- This triggers the Process below, which will condition which numbers and letters are displayed on the LCD as the 4-Bit Variable counts up past #9 or 1001
                                    -------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    
                                    -- if the number is Greater than 9..... meaning the number is now in the Realm of HEX... A,B,C,D,E,F... then
                                    if ( to_integer(unsigned(next_char(3 downto 0))) > 9) then 
                              
                                    -- See the ASCII CHART... Letters A...F are in Column  x"4"
                                      data_bus_value <= x"4" & std_logic_vector(to_unsigned(( to_integer(unsigned(next_char(3 downto 0)))   -   9   ), 4)); 
                                    else 
                                
                                    -- See the ASCII CHART... Numbers 0...9 are in Column x"3"
                                      data_bus_value <= x"3" & next_char(3 downto 0);
                                    end if;
                               end if;
                          
                          
                          

                            -- Loop to send out 32 characters to LCD Display (16 by 2 lines)
                               if ( to_integer(unsigned(char_count))  < 31) AND (next_char /= x"fe") then
                                   char_count <= std_logic_vector(to_unsigned(to_integer(unsigned(char_count)) +1, 5));                            
                               else
                                   char_count <= "00000";
                               end if;
                  
                  
                  
                            -- Jump to second line?
                               if (to_integer(unsigned(char_count)) = 15) then 
                                  next_command <= line2;
                   
                   
                   
                            -- Return to first line?
                               elsif (to_integer(unsigned(char_count)) = 31) or (next_char = x"fe") then
                                     next_command <= return_home;
                               else 
                                     next_command <= print_string; 
                               end if; 
                 
                 
                 
                       -- Set write address to line 2 character 1
                       --======================================--
                       when line2 =>
                            LCD_EN <= '1';
                            LCD_RS <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"c0";
                            state <= drop_lcd_e;
                            next_command <= print_string;      
                     
                     
                       -- Return write address to first character position on line 1
                       --=========================================================--
                       when return_home =>
                            LCD_EN <= '1';
                            LCD_RS <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"80";
                            state <= drop_lcd_e;
                            next_command <= print_string; 
                    
                    
                    
                       -- The next states occur at the end of each command or data transfer to the LCD
                       -- Drop LCD E line - falling edge loads inst/data to LCD controller
                       --============================================================================--
                       when drop_lcd_e =>
                            state <= next_command;
                            LCD_EN <= '0';
                            LCD_BLON <= '1';
                            LCD_ON   <= '1';
                        end case;




             end if;-- CLOSING STATEMENT FOR "IF clk_400hz_enable = '1' THEN"
             
      end if;-- CLOSING STATEMENT FOR "IF reset = '0' THEN" 
      
end process;                                                            
  
END ARCHITECTURE LCD_DISPLAY_arch;