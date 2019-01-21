----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2018 07:16:53 PM
-- Design Name: 
-- Module Name: ExecutionUnit - Behavioral
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

entity ExecutionUnit is
Port(
	PCOut:in std_logic_vector(15 downto 0);
	RD1: in std_logic_vector(15 downto 0);
	RD2: in std_logic_vector(15 downto 0);
	Ext_Imm: in std_logic_vector(15 downto 0);
	Func: in std_logic_vector(2 downto 0);
	SA: in std_logic;
	ALUSrc: in std_logic;
	ALUOp: in std_logic_vector(2 downto 0);
	BranchAddress: out std_logic_vector(15 downto 0);
	ALURes: out std_logic_vector(15 downto 0);
	ZeroSignal: out std_logic);
end ExecutionUnit;

architecture Behavioral of ExecutionUnit is

signal AluIn2:std_logic_vector(15 downto 0);
signal ALUControl: std_logic_vector(3 downto 0);
signal ALUResAux:std_logic_vector(15 downto 0);
signal ZeroAux: std_logic;

begin

BranchAddress<=PCOut+Ext_Imm;

with ALUSrc select
	AluIn2<=RD2 when '0',
			  Ext_Imm when others;
			  

process(ALUOp,Func)
begin
	case (ALUOp) is
		when "000"=>
				case (Func) is
					when "000"=> ALUControl<="0000"; 	    -----ADD-----
					when "001"=> ALUControl<="0001";		-----SUB-----
					when "010"=> ALUControl<="0010";		-----SLL-----
					when "011"=> ALUControl<="0011";		-----SRL-----
					when "100"=> ALUControl<="0100";		-----AND-----
					when "101"=> ALUControl<="0101";		-----OR-----
					when "110"=> ALUControl<="0110";		-----XOR-----
					when "111"=> ALUControl<="0111";		-----SLT-----
					when others=> ALUControl<="0000";	-----OTHERS-----
				end case;
				
		when "001"=> ALUControl<="0000";		-----ADDI-----
		when "010"=> ALUControl<="0001";		-----BEQ-----
		when "101"=> ALUControl<="0100";		-----ANDI-----
		when "110"=> ALUControl<="0101";		-----ORI-----
		when "111"=> ALUControl<="1000";		-----JUMP-----
		when others=> ALUControl<="0000";	
	end case;
end process;

process(ALUControl,RD1,AluIn2,SA)
begin
	case(ALUControl) is
		when "0000" => ALUResAux<=RD1+AluIn2;  
		when "0001" => ALUResAux<=RD1-AluIn2;	 			
		when "0010" => 				-----SLL-----
					case (SA) is
						when '1' => ALUResAux<=RD1(14 downto 0) & "0";
						when others => ALUResAux<=RD1;	
					end case;				
		when "0011" => 				-----SRL-----
					case (SA) is
						when '1' => ALUResAux<="0" & RD1(15 downto 1);
						when others => ALUResAux<=RD1;
					end case;				
		when "0100" => ALUResAux<=RD1 and AluIn2;		
		when "0101" => ALUResAux<=RD1 or AluIn2;	
		when "0110" => ALUResAux<=RD1 xor AluIn2;							
		when "0111" =>   -----SET ON LESS THAN-----
					if RD1<AluIn2 then
						ALUResAux<=X"0001";
					else ALUResAux<=X"0000";
					end if;
		when "1000" => ALUResAux<=X"0000";	-----JUMP-----
		when others => ALUResAUx<=X"0000";	-----OTHERS-----
	end case;

	case (ALUResAux) is					
		when X"0000" => ZeroAux<='1';
		when others => ZeroAux<='0';
	end case;

end process;

ZeroSignal<=ZeroAux;			
ALURes<=ALUResAux;			

end Behavioral;
