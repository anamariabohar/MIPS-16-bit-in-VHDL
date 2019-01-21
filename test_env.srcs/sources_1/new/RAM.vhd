----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2018 07:19:14 PM
-- Design Name: 
-- Module Name: RAM - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is
    Port ( RA1 : in STD_LOGIC_VECTOR (3 downto 0);
           WA : in STD_LOGIC_VECTOR (3 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           WE : in STD_LOGIC;
           clk : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0));
end RAM;

architecture Behavioral of RAM is


type memorie is array (0 to 15) of STD_LOGIC_VECTOR (15 downto 0);
signal mem: memorie := (
    0=> "0000000000000000",
    1=> "0000000000000001",
    2=> "0000000000000010",
    3=> "0000000000000011",
    4=> "0000000000000100",
    5=> "0000000000000101",
    6=> "0000000000000110",
    7=> "0000000000000111",
    8=> "0000000000001000",
    9=> "0000000000001001",
    10=> "0000000000010000",
    others => x"9999"
    );

begin

    RD1<=mem(conv_integer(RA1));

    process(clk,WE) 
      begin
            if rising_edge(clk)then
                if WE='1' then
                     mem(conv_integer(WA))<=WD; 
                end if;
            end if;
    end process;
    
end Behavioral;
