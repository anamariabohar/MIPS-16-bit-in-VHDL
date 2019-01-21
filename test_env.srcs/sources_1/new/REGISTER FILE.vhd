----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2018 07:15:44 PM
-- Design Name: 
-- Module Name: REGISTER_FILE - Behavioral
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity REGISTER_FILE is
    Port (	clk : in std_logic;
				ReadAddress1 : in std_logic_vector (2 downto 0);
				ReadAddress2 : in std_logic_vector (2 downto 0);
				WriteAddress : in std_logic_vector (2 downto 0);
				WriteData : in std_logic_vector (15 downto 0);
				RegWrite : in std_logic;
				EnableMPG: in std_logic;
				ReadData1 : out std_logic_vector (15 downto 0);
				ReadData2 : out std_logic_vector (15 downto 0));
end REGISTER_FILE;

architecture Behavioral of REGISTER_FILE is


type reg_array is array(0 to 7) of std_logic_vector(15 downto 0);
signal reg_file : reg_array:=(
		X"0000",
		X"0001",
		X"0002",
		X"0003",
		X"0004",
		X"0005",
		X"0006",
		X"0007",
		others => X"0000");
begin

ReadData1 <= reg_file(conv_integer(ReadAddress1));			-----registru de la adresa RS-----
ReadData2 <= reg_file(conv_integer(ReadAddress2));			-----registru de la adresa RT-----

process(clk,EnableMPG)			
begin
	if EnableMPG='1' then
		if rising_edge(clk) and RegWrite='1' then
			reg_file(conv_integer(WriteAddress))<=WriteData;		
		end if;
	end if;
end process;		

end Behavioral;