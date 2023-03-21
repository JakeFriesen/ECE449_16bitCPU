----------------------------------------------------------------------------------
-- Company: University of Victoria ECE 449
-- Engineer: Matthew Ebert
-- 
-- Create Date: 2023-FEB-16 
-- Module Name: EX Stage - Behavioral
-- Project Name: 16-bit CPU
-- Target Devices: Basys3 FPGA
-- 
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library work;
use work.Constant_Package.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;


entity ForwardingUnit is
    Port ( 
            clk: in STD_LOGIC;
            rst: in STD_LOGIC;
            IR_EX_inF: in   std_logic_vector(15 downto 0);
            IR_MEM_inF: in   std_logic_vector(15 downto 0);
            IR_WB_inF: in   std_logic_vector(15 downto 0);
            A_EX_inF : out STD_LOGIC_VECTOR (15 downto 0);
            B_EX_inF : out  STD_LOGIC_VECTOR (15 downto 0);   
            A_ID_outF : in STD_LOGIC_VECTOR (15 downto 0);
            B_ID_outF : in STD_LOGIC_VECTOR (15 downto 0);
            A_MEM_inF : in STD_LOGIC_VECTOR (15 downto 0);
            B_MEM_inF : in STD_LOGIC_VECTOR (15 downto 0);     
            Result_MEM_inF : in STD_LOGIC_VECTOR (15 downto 0);
            Result_WB_inF: in STD_LOGIC_VECTOR (15 downto 0);
            Memdata_WB_inF: in STD_LOGIC_VECTOR (15 downto 0);
            Write_data_inF: in STD_LOGIC_VECTOR (15 downto 0);
            Write_addr_inF: in STD_LOGIC_VECTOR (2 downto 0);
            Write_en_inF: in STD_LOGIC;
            halt: out std_logic
           );
         
end ForwardingUnit;

architecture Behavioral of ForwardingUnit is

signal opEX,opMEM, opWB : std_logic_vector(6 downto 0);
signal r1EX,r2EX, raEX, rbEX, rcEX, raWB, rbWB, rcWB, raMEM, rbMEM, rcMEM: std_logic_vector(2 downto 0);
signal A_forward_MEM, B_forward_MEM, A_forward_WB, B_forward_WB: std_logic_vector(15 downto 0);
signal sw_WB, en_REG, en_MEM, en_EX, en_WB, A_EX_sel, B_EX_sel : std_logic_vector(1 downto 0);

begin

--------------------------EX DATA----------------------------
opEX <= IR_EX_inF(15 downto 9);
--check that data in buffer is valid for forwarding
with opEX select
        en_EX <=   (others=>'0') when nop_op | in_op,
                   (others=>'1') when others;

 
raEX <= IR_EX_inF(8 downto 6); 
rbEX <= IR_EX_inF(5 downto 3); 
rcEX <= IR_EX_inF(2 downto 0); 

with opEX select
    r1EX <=    raEX when store_op,
                rbEX when others;
with opEX select
    r2EX <=    rbEX when store_op,
                rcEX when others;
----------------------------MEM DATA----------------------------
opMEM <= IR_MEM_inF(15 downto 9);
--check that data in buffer is valid for forwarding
with opMEM select
        en_MEM <=   (others=>'0') when nop_op | store_op,
                    (others=>'1') when others;


raMEM <= IR_MEM_inF(8 downto 6);
rbMEM <= IR_MEM_inF(5 downto 3);
rcMEM <= IR_MEM_inF(2 downto 0);
						
----------------------------WB DATA----------------------------
opWB <= IR_WB_inF(15 downto 9);
--check that data in buffer is valid for forwarding
with opWB select
        sw_WB <=    "01" when load_op,
                    "00" when others;

with opWB select
        en_WB <=   (others=>'0') when nop_op | store_op,
                   (others=>'1') when others;

raWB <= IR_WB_inF(8 downto 6);
rbWB <= IR_WB_inF(5 downto 3);
rcWB <= IR_WB_inF(2 downto 0); 

----------------------------REGDATA----------------------------
opWB <= IR_WB_inF(15 downto 9);
--check that data in buffer is valid for forwarding
with Write_en_inF select
        en_REG <=   (others=>'0') when '0',
                    (others=>'1') when others;





----------------------------FORWARDING----------------------------
--determine if forwarding is available for A
with r1EX select
    A_EX_sel <=  
                    (("10" and en_EX and en_WB) or sw_WB) when raWB, --this produces "11" or "10"
                    ("01" and en_EX  and en_MEM) when raMEM ,
                     "00" when others;
 --determine if forwarding is available for B               
with r2EX select
    B_EX_sel <=   
                    (("10" and en_EX and en_WB) or sw_WB) when raWB, --this produces "11" or "10"
                    ("01" and en_EX and en_MEM) when raMEM ,
                     "00" when others;
                
--Select which data to send to A
with A_EX_sel select	
    A_EX_inF <=     Memdata_WB_inF when "11",
                    Result_WB_inF when "10",
                    Result_MEM_inF when "01",
                    A_ID_outF when others;
                    
--Select which data to send to B           
with B_EX_sel select	
    B_EX_inF <=     Memdata_WB_inF when "11",
                    Result_WB_inF when "10",
                    Result_MEM_inF when "01",
                    B_ID_outF when others;



halt <= '1' when (opMEM = load_op) and ((B_EX_sel = "01") or (A_EX_sel = "01")) else '0';

     
end Behavioral;
