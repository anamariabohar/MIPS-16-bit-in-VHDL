----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2018 07:13:43 PM
-- Design Name: 
-- Module Name: IDecode - Behavioral
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

entity IDecode is
	Port ( clk: in std_logic;
			Instruction: in std_logic_vector(15 downto 0);
			WriteData: in std_logic_vector(15 downto 0);
			RegWrite: in std_logic;
			RegWrite2: in std_logic;
			RegDst: in std_logic;
			ExtOp: in std_logic;
			ReadData1: out std_logic_vector(15 downto 0);
			ReadData2: out std_logic_vector(15 downto 0);
			Ext_Imm : out std_logic_vector(15 downto 0);
			Func : out std_logic_vector(2 downto 0);
			SA : out std_logic);		
end IDecode;

architecture Behavioral of IDecode is

------------------componenta Register_file-------------
component REGISTER_FILE is
    Port (	clk : in std_logic;
            ReadAddress1 : in std_logic_vector (2 downto 0);
            ReadAddress2 : in std_logic_vector (2 downto 0);
            WriteAddress : in std_logic_vector (2 downto 0);
            WriteData : in std_logic_vector (15 downto 0);
            RegWrite : in std_logic;
            EnableMPG: in std_logic;
            ReadData1 : out std_logic_vector (15 downto 0);
            ReadData2 : out std_logic_vector (15 downto 0));
end component;


signal ReadAddress1: std_logic_vector(2 downto 0);
signal ReadAddress2: std_logic_vector(2 downto 0);
signal WriteAddress: std_logic_vector(2 downto 0):="000";
signal ExtImm: std_logic_vector(15 downto 0);

begin

process(RegDst,Instruction)	
begin
	case (RegDst) is
		when '0' => WriteAddress <=Instruction(9 downto 7);
		when '1' => WriteAddress <=Instruction(6 downto 4);
		when others=>WriteAddress<=WriteAddress;
	end case;
end process;

process(ExtOp,Instruction)   
begin
	case (ExtOp) is
		when '1' => 	
				case (Instruction(6)) is
					when '0' => ExtImm <= B"000000000" & Instruction(6 downto 0);
					when '1' =>  ExtImm <=	B"111111111" & Instruction(6 downto 0);
					when others => ExtImm <= ExtImm;
				end case;
		when others => ExtImm <= B"000000000" & Instruction(6 downto 0);
	end case;
end process;

Func<=Instruction(2 downto 0);	
SA<=Instruction(3);					
Ext_Imm <= ExtImm;					

ReadAddress1<=Instruction(12 downto 10);		
ReadAddress2<=Instruction(9 downto 7);			

------REG_FILE--------------
RF1: REGISTER_FILE port map (clk=>clk,ReadAddress1=>ReadAddress1,ReadAddress2=>ReadAddress2,WriteAddress=>WriteAddress,WriteData=>WriteData,RegWrite=>RegWrite,EnableMPG=>RegWrite2,ReadData1=>ReadData1,ReadData2=>ReadData2);

end Behavioral;
