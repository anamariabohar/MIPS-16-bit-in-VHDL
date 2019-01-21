----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2018 07:11:06 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( digit : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end SSD;

architecture Behavioral of SSD is
signal count_int:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal x:STD_LOGIC_VECTOR(3 downto 0);
begin


process(clk)
begin
    if rising_edge(clk) then
        count_int<=count_int+1;
    end if;
end process;

process(count_int(15 downto 0), digit)
begin
    case count_int(15 downto 14) is
        when "00" =>x<=digit(3 downto 0);
                        an<="1110";
        when "01" =>x<=digit(7 downto 4);
                        an<="1101";
        when "10" =>x<=digit(11 downto 8);
                        an<="1011";
        when "11" =>x<=digit(15 downto 12);
                        an<="0111";
        when others =>x<=digit(15 downto 12);
                        an<="1111";
    end case;
end process;

process(x)
begin
case x is            
			 when X"0" => cat <= "1000000"; --0;
			 when X"1" => cat <= "1111001"; --1
			 when X"2" => cat <= "0100100"; --2
			 when X"3" => cat <= "0110000"; --3
			 when X"4" => cat <= "0011001"; --4
			 when X"5" => cat <= "0010010"; --5
			 when X"6" => cat <= "0000010"; --6
			 when X"7" => cat <= "1111000"; --7
			 when X"8" => cat <= "0000000"; --8
			 when X"9" => cat <= "0010000"; --9
			 when X"A" => cat <= "0001000"; --A
			 when X"B" => cat <= "0000011"; --b
			 when X"C" => cat <= "1000110"; --C
			 when X"D" => cat <= "0100001"; --d
			 when X"E" => cat <= "0000110"; --E
			 when X"F" => cat <= "0001110"; --F
			 when others => cat <= "0111111"; -- gol
		end case;
end process;
		

end Behavioral;
