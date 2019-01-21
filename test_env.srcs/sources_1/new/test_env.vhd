----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2018 07:05:14 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

-----------------ALU signals-------------------------
--signal rez:STD_LOGIC_VECTOR(15 downto 0);
--signal x: STD_LOGIC_VECTOR(15 downto 0):=x"0000";
--signal y: STD_LOGIC_VECTOR(15 downto 0):=x"0000";
--signal z: STD_LOGIC_VECTOR(15 downto 0):=x"0000";


----------------REGISTER_FILE signals------------
--signal count_int:STD_LOGIC_VECTOR(3 downto 0);
--signal digit0:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
--signal digit1:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
--signal digit2:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
--signal WE:STD_LOGIC;
--signal reset:STD_LOGIC;
--signal en:STD_LOGIC;
	
		
----------------RAM memory signals------------
--signal digit2:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
--signal count_int:STD_LOGIC_VECTOR(3 downto 0):="0000";
--signal en:STD_LOGIC;
--signal reset:STD_LOGIC;
--signal WE:STD_LOGIC;
--signal digit3:STD_LOGIC_VECTOR(15 downto 0);


signal enable: STD_LOGIC;   
signal enable2: STD_LOGIC;	  
signal BranchAddress:std_logic_vector(15 downto 0);  	  
signal JumpAddress:std_logic_vector(15 downto 0); 		   
signal SSDOUT : std_logic_vector(15 downto 0):=X"0000";  
signal InstrOut: std_logic_vector(15 downto 0);			   
signal PCout: std_logic_vector(15 downto 0);				  
signal ALURes: std_logic_vector(15 downto 0);			  
signal ZeroSignal: std_logic;										
signal Ext_Imm : std_logic_vector(15 downto 0);				
signal Func :std_logic_vector(2 downto 0);					
signal SA : std_logic;												
signal MemData: std_logic_vector(15 downto 0);				
signal ALUResFinal: std_logic_vector(15 downto 0);			
signal WriteDataReg: std_logic_vector(15 downto 0);		
signal PCSrc:std_logic;												
signal ReadData1: std_logic_vector(15 downto 0);					
signal ReadData2: std_logic_vector(15 downto 0);
signal RegDst: std_logic;
signal ExtOp: std_logic;
signal ALUSrc: std_logic;
signal Branch: std_logic;
signal Jump: std_logic;
signal ALUOp: std_logic_vector(2 downto 0);
signal MemWrite: std_logic;
signal MemtoReg: std_logic;
signal RegWrite: std_logic;
signal IF_ID:std_logic_vector(31 downto 0);
signal ID_EX:std_logic_vector(78 downto 0);	
signal MuxOUT:std_logic_vector(2 downto 0);
signal EX_MEM:std_logic_vector(39 downto 0);
signal MEM_WB:std_logic_vector(36 downto 0);			

----------COMPONENTS-----------
component MPG is
    Port ( btn : in STD_LOGIC;
        clk : in STD_LOGIC;
        en : out STD_LOGIC);     
end component;

component SSD is
    Port ( digit : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

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

component RAM is
Port ( RA1 : in STD_LOGIC_VECTOR (3 downto 0);
       WA : in STD_LOGIC_VECTOR (3 downto 0);
       WD : in STD_LOGIC_VECTOR (15 downto 0);
       WE : in STD_LOGIC;
       clk : in STD_LOGIC;
       RD1 : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component IFetch is
	Port (WE : in std_logic;
        reset : in std_logic;
        clk: in std_logic;
        BranchAddress : in std_logic_vector(15 downto 0);
        JumpAddress : in std_logic_vector(15 downto 0);
        JCS : in std_logic;
        PCSrc : in std_logic;
        Instruction : out std_logic_vector(15 downto 0);
        PC : out std_logic_vector(15 downto 0));
end component;

component IDecode is
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
end component;

component ControlUnit is
Port	( Instr:in std_logic_vector(2 downto 0);
         RegDst: out std_logic;
         ExtOp: out std_logic;
         ALUSrc: out std_logic;
         Branch: out std_logic;
         Jump: out std_logic;
         ALUOp: out std_logic_vector(2 downto 0);
         MemWrite: out std_logic;
         MemtoReg: out std_logic;
         RegWrite: out std_logic);
end component;


component DataMemory is
	port(
			clk: in std_logic;--
			ALURes : in std_logic_vector(15 downto 0);
			WriteData: in std_logic_vector(15 downto 0);
			MemWrite: in std_logic;		
			MemWriteCtrl: in std_logic;				
			MemData:out std_logic_vector(15 downto 0);--
			ALURes2 :out std_logic_vector(15 downto 0)--
	);
end component;

component ExecutionUnit is
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
end component;


begin

-----REGISTER_FILE--------
--led(3 downto 0) <= count_int;  

---ROM memory-------
--led(7 downto 0) <= count_int;

------RAM memory----------
--led(3 downto 0)<=count_int;

----------ALU switches-------
--x(3 downto 0)<=sw(3 downto 0);
--y(3 downto 0)<=sw(7 downto 4);
--z(7 downto 0)<=sw(7 downto 0);
  
  
----Pentru orice inainte de IF---------------
--process(clk) 
 --begin  
 --if reset='1' then
        --count_int<="0000"; --------REGISTER_FILE
        --count_int<="00000000";-----------ROM memory
        --count_int<="0000"; ------------RAM memory
 --end if;  
 --if rising_edge(clk) then
  --if en='1' then
         --count_int<=count_int+1;
      -- end if;
     --end if;
--end process;


-------MPG+Counter+Decoder----------------
--process(clk)
--begin
--if rising_edge(clk) then
--    if en='1' then
--      count_int<=count_int+1;
--    end if;
--end if;
--end process;

--     led(7 downto 0)<= 
--     "00000001" when  count_int="000" else
--     "00000010" when  count_int="001" else
--     "00000100" when  count_int="010" else
--     "00001000" when  count_int="011" else
--     "00010000" when  count_int="100" else
--     "00100000" when  count_int="101" else
--     "01000000" when  count_int="110" else
--     "10000000" when  count_int="111";


--------------ALU------------------
--process(count_int,x,y,z)
--begin
  --  case count_int is
       -- when "00" =>rez<=x+y;
       -- when "01" =>rez<=x-y;
       -- when "10" =>rez(15 downto 2)<=z(13 downto 0);
       --             rez(1 downto 0)<="00";
      --  when others =>rez(13 downto 0)<=z(15 downto 2);
      --                   rez(15 downto 14)<="00";
   -- end case;
--end process;

---------------ROM memory------------
 --DO<=ROM(conv_integer(count_int));
 --M1:MPG port map(btn=>btn(0),clk=>clk,en=>en);
 --M2:MPG port map(btn=>btn(1),clk=>clk,en=>reset);
 --S1:SSD port map(digit=>do,clk=>clk,cat=>cat,an=>an);

--------------RAM memory-------------
--digit3<=digit2(13 downto 0)&"00";
--M1:MPG port map(btn=>btn(0),clk=>clk,en=>en);
--M2:MPG port map(btn=>btn(2),clk=>clk,en=>WE);
--M3:MPG port map(btn=>btn(1),clk=>clk,en=>reset);
--R1:RAM port map(RA1=>count_int,WA=>count_int,WD=>digit3,WE=>WE,clk=>clk,RD1=>digit2);
--S1:SSD port map(digit=>digit3,clk=>clk,cat=>cat,an=>an);

-------------IFetch--------------------
M1:MPG port map(btn=>btn(0),clk=>clk,en=>enable);
M2:MPG port map(btn=>btn(1),clk=>clk,en=>enable2);
S1:SSD port map(digit=>SSDOut,clk=>clk,cat=>cat,an=>an);
IF1:IFetch port map(WE=>enable,RESET=>enable2,clk=>clk,BranchAddress=>BranchAddress,JumpAddress=>JumpAddress,JCS=>Jump,PCSrc=>PCSrc,Instruction=>InstrOut,PC=>PCout);
------------------------------------------------------
--process(Jump,PCSrc)
--begin
--    if sw(0)='1' then
--        if PCSrc='0' then
--             Jump<='1';
--        end if;
--    end if;
--    if sw(1)='1' then 
--        if Jump<='0' then
--            PCSrc<='1';
--        end if;
--    end if;
--end process;
----------------------------------------------------------

-----------Write Back Unit------------------
process(MemtoReg,ALUResFinal,MemData)
begin
	case (MemtoReg) is
		when '1' => WriteDataReg<=MemData;
		when '0' => WriteDataReg<=ALUResFinal;
		when others => WriteDataReg<=WriteDataReg;
	end case;
end process;	
---------------------------------

PCSrc<=ZeroSignal and Branch;

JumpAddress<=PCOut(15 downto 14) & InstrOut(13 downto 0);

---------------IDecode-------------
ID1 : IDecode port map (clk=>clk,Instruction=>InstrOut,WriteData=>WriteDataReg,RegWrite=>RegWrite,RegWrite2=>enable,RegDst=>RegDst,ExtOp=>ExtOp,ReadData1=>ReadData1,ReadData2=>ReadData2,Ext_Imm=>Ext_Imm,Func=>Func,SA=>SA);
-------------------------------------------------

process(InstrOut,PCout,ReadData1,ReadData2,Ext_Imm,ALURes,MemData,WriteDataReg,sw)
begin
	case(sw(7 downto 5)) is
		when "000"=> SSDOut <=InstrOut;
		when "001"=> SSDOut <=PCout;				
    	when "010"=> SSDOut <=ReadData1;				
		when "011"=> SSDOut <=ReadData2;				
		when "100"=> SSDOut <=Ext_Imm;			
		when "101"=> SSDOut <=ALURes;                    
        when "110"=> SSDOut <=MemData;           
        when "111"=> SSDOut <=WriteDataReg;    
        when others=> SSDOut <=X"AAAA";
    end case;
end process;

-------------------------------------------------	

--------ControlUnit------------
CU1 : ControlUnit port map (Instr=>InstrOut(15 downto 13),RegDst=>RegDst,ExtOp=>ExtOp,ALUSrc=>ALUSrc,Branch=>Branch,Jump=>Jump,ALUOp=>ALUOp,MemWrite=>MemWrite,MemtoReg=>MemtoReg,RegWrite=>RegWrite);
-------------------------------------------------

------ExecutionUnit--------------
EU1 : ExecutionUnit port map(PCOut=>PCOut,RD1=>ReadData1,RD2=>ReadData2,Ext_Imm=>Ext_Imm,Func=>Func,SA=>SA,ALUSrc=>ALUSrc,ALUOp=>ALUOp,BranchAddress=>BranchAddress,ALURes=>ALURes,ZeroSignal=>ZeroSignal);
-------------------------------------------------

------DataMemory--------------
MY1 : DataMemory port map(clk=>clk,ALURes=>ALURes,WriteData=>ReadData2,MemWrite=>MemWrite,MemWriteCtrl=>enable,MemData=>MemData,ALURes2=>ALUResFinal);
-------------------------------------------------
---------Afisarea semnalelor de control------------
process(RegDst,ExtOp,ALUSrc,Branch,Jump,MemWrite,MemtoReg,RegWrite,sw,ALUOp)
begin
	if sw(0)='0' then		
		led(7)<=RegDst;
		led(6)<=ExtOp;
		led(5)<=ALUSrc;
		led(4)<=Branch;
		led(3)<=Jump;
		led(2)<=MemWrite;
		led(1)<=MemtoReg;
		led(0)<=RegWrite;
	else
		led(2 downto 0)<=ALUOp(2 downto 0);
		led(7 downto 3)<="00000";
	end if;
end process;	
---------------------------------------------------------------------------


----------PIPELINE---------------------
--------------IF/ID--------------------
--process(clk, enable)
--begin
--    if rising_edge(CLK) then 
--        if enable='1' then 
--            IF_ID(31 downto 16)<=PCOut;
--            IF_ID(15 downto 0)<=InstrOut;
--         end if;
--         end if;
--end process;
-------------------------------------------

---------------ID/EX-----------------------
--process(CLK,enable)
--begin 
--    if rising_edge(CLK) then
--        if enable='1' then 
--            ID_EX(0)<=MemtoReg;
--            ID_EX(1)<=RegWrite;
--            ID_EX(2)<=MemWrite;
--            ID_EX(3)<=Branch;
--            ID_EX(6 downto 4)<=AluOp;
--            ID_EX(7)<=AluSrc;
--            ID_EX(8)<=RegDst;
--            ID_EX(24 downto 9)<=IF_ID(31 downto 16);
--            ID_EX(40 downto 25)<=ReadData1;
--            ID_EX(56 downto 41)<=ReadData2;
--            ID_EX(72 downto 57)<=Ext_Imm;
--            ID_EX(75 downto 73)<=Func;
--            ID_Ex(79 downto 76)<=MuxOut;
--      end if;
--      end if;
--end process;

---------------EX/MEM---------------------
--process(CLK,enable)
--begin
--    if rising_edge(CLK) then
--        if enable='1' then 
--            EX_MEM(0)<=ID_EX(0);
--            EX_MEM(1)<=ID_EX(1);
--            EX_MEM(2)<=ID_EX(2);
--            EX_MEM(3)<=ID_EX(3);
--            EX_MEM(4)<=ZeroSignal;
--            EX_MEM(20 downto 5)<=AluResFinal;
--            EX_MEM(36 downto 21)<=ReadData2;
--            EX_MEM(39 downto 37)<=MuxOut;
--    end if;
--    end if;
--end process;

----------------MEM/WB-----------------------
--process(CLK,enable)
--begin 
--    if rising_edge(CLK) then
--        if enable='1' then
--            MEM_WB(0)<=EX_MEM(0);
--            MEM_WB(1)<=EX_MEM(1);
--            MEM_WB(17 downto 2)<=MemData;
--            MEM_WB(33 downto 18)<=AluResFinal;
--       end if;
--       end if;
--end process;

end Behavioral;
