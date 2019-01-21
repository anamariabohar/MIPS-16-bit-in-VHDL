----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2018 07:17:43 PM
-- Design Name: 
-- Module Name: DataMemory - Behavioral
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

entity DataMemory is
	port(clk: in std_logic;
        ALURes : in std_logic_vector(15 downto 0);
        WriteData: in std_logic_vector(15 downto 0);
        MemWrite: in std_logic;			
        MemWriteCtrl: in std_logic;	
        MemData:out std_logic_vector(15 downto 0);
        ALURes2 :out std_logic_vector(15 downto 0));
end DataMemory;

architecture Behavioral of DataMemory is

signal Address: std_logic_vector(3 downto 0);

type ram_type is array (0 to 15) of std_logic_vector(15 downto 0);
signal RAM:ram_type:=(
		X"000A",
		X"000B",
		X"000C",
		X"000D",
		X"000E",
		X"000F",
		X"0009",
		X"0008",
		others =>X"0000");

begin

process(clk) 			
begin
	if(rising_edge(clk)) then
		if MemWriteCtrl='1' then
			if MemWrite='1' then
				RAM(conv_integer(Address))<=WriteData;			
			end if;
		end if;	
	end if;
	MemData<=RAM(conv_integer(Address));
end process;

Address<=ALURes(3 downto 0);	
ALURes2<=ALURes;		

end Behavioral;
