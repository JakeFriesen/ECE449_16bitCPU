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
            loadIMM_inF: in std_logic;
            R7_data_inF: in std_logic_vector(15 downto 0); 
            halt: out std_logic
           );
         
end ForwardingUnit;

architecture Behavioral of ForwardingUnit is

signal opEX,opMEM, opWB : std_logic_vector(6 downto 0);
signal r1EX,r2EX, raEX, rbEX, rcEX, raWB, rbWB, rcWB, raMEM, rbMEM, rcMEM: std_logic_vector(2 downto 0);
signal A_forward_MEM, B_forward_MEM, A_forward_WB, B_forward_WB, loadIMM_data, loadIMM_data_intr: std_logic_vector(15 downto 0);
signal en_REG, en_MEM, en_EX, en_WB, loadIMM_en: std_logic;
signal sw_WB, A_EX_sel, B_EX_sel, case2 : std_logic_vector( 2 downto 0);
signal en_Mov: std_logic ;

begin

--------------------------EX DATA----------------------------
opEX <= IR_EX_inF(15 downto 9);
--check that data in buffer is valid for forwarding
with opEX select
        en_EX <=   '0' when nop_op | in_op | loadIMM_op | pop_op | BRR_op | brr_n_op | brr_z_op,
                   '1' when others;

 
raEX <= IR_EX_inF(8 downto 6); 
rbEX <= IR_EX_inF(5 downto 3); 
rcEX <= IR_EX_inF(2 downto 0); 

with opEX select
    r1EX <=     raEX when store_op | mov_op | load_op | SHL_op | SHR_op | test_op | brr_op | brr_n_op | brr_z_op | br_op |out_op | br_z_op | br_sub_op | push_op,
                rbEX when others;
with opEX select
    r2EX <=    rbEX when store_op  | load_op | mov_op,
                rcEX when others;
----------------------------MEM DATA----------------------------
opMEM <= IR_MEM_inF(15 downto 9);


    
--check that data in buffer is valid for forwarding
with opMEM select
        en_MEM <=   '0' when nop_op | store_op | loadIMM_op | BRR_op | brr_n_op | brr_z_op,
                    '1' when others;


raMEM <= IR_MEM_inF(8 downto 6);
rbMEM <= IR_MEM_inF(5 downto 3);
rcMEM <= IR_MEM_inF(2 downto 0);
						
----------------------------WB DATA----------------------------
opWB <= IR_WB_inF(15 downto 9);
--check that data in buffer is valid for forwarding
with opWB select
        sw_WB <=    "001" when load_op,
                    "000" when others;


en_WB <=   '0' when OPWB = nop_op or OPWB = store_op  or OPWB = loadIMM_OP or OPWB = BRR_OP or OPWB = BRR_N_OP or OPWB = BRR_Z_OP else
           '0' when raWB = raMEM else
           '1';

raWB <= IR_WB_inF(8 downto 6);
rbWB <= IR_WB_inF(5 downto 3);
rcWB <= IR_WB_inF(2 downto 0); 

----------------------------REGDATA----------------------------
opWB <= IR_WB_inF(15 downto 9);



--check that data in buffer is valid for forwarding
with Write_en_inF select
        en_REG <=   '0' when '0',
                    '1' when others;


--get load IMM_data

with IR_WB_inF(15 downto 8) select
    loadIMM_data_intr <=        IR_WB_inF(7 downto 0) & R7_data_inF(7 downto 0) when (loadIMM_op & '1'),
                                R7_data_inF(15 downto 8) & IR_WB_inF(7 downto 0) when (loadIMM_op & '0'),
                                R7_data_inF when others;

with IR_MEM_inF(15 downto 8) select
    loadIMM_data <=     IR_MEM_inF(7 downto 0) & loadIMM_data_intr(7 downto 0) when (loadIMM_op & '1'),
                        loadIMM_data_intr(15 downto 8) & IR_MEM_inF(7 downto 0) when (loadIMM_op & '0'),
                        loadIMM_data_intr when others;


loadIMM_en <= '1' when ((loadIMM_inF = '1') or (opMEM = loadIMM_op) or (opWB = loadIMM_op)) else '0';

en_Mov <= '1' when (opEX = mov_op and opMEM = mov_op) else '0';
----------------------------FORWARDING----------------------------
--determine if forwarding is available for A


A_EX_sel <= ("101") when r2EX = raMEM and en_Mov = '1' and en_EX = '1' and en_MEM = '1' else
            ("100" ) when r1EX = "111" and loadIMM_en= '1' and en_EX = '1' else
            (("010") or sw_WB) when r1EX = raWB and en_WB = '1' and en_EX = '1' else
            ("001") when r1EX = raMEM and en_EX = '1' and en_MEM = '1' else
            "000"; 
            
B_EX_sel <= ("100") when r2EX = "111" and loadIMM_en = '1' and en_EX = '1' else
            (("010") or sw_WB) when r2EX = raWB and en_WB = '1' and en_EX = '1'  else
            ("001") when r2EX = raMEM and en_MEM = '1' and en_EX = '1'  else
            "000"; 
                
--Select which data to send to A
with A_EX_sel select	
    A_EX_inF <=     A_MEM_inf when "101",
                    loadIMM_data when "100",
                    Memdata_WB_inF when "011",
                    Result_WB_inF when "010",
                    Result_MEM_inF when "001",
                    A_ID_outF when others;
                    
--Select which data to send to B           
with B_EX_sel select	
    B_EX_inF <=     loadIMM_data when "100",
                    Memdata_WB_inF when "011",
                    Result_WB_inF when "010",
                    Result_MEM_inF when "001",
                    B_ID_outF when others;


                    --A type after L-type                                   
halt <= '1' when ((opMEM = load_op) and ((B_EX_sel = "01") or (A_EX_sel = "01"))) else '0';
     
end Behavioral;
