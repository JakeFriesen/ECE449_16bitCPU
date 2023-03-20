---------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Course: University of Victoria
-- Engineer: Jake Friesen, Matthew Ebert, Samuel Pacheo 
-- 
-- Create Date: 2023-Mar-09

-- Module Name: Write_Back_Stage - Behavioral
-- Project Name: 16bitCPU
-- Target Devices: Artix7
-- Description: 
-- 
-- Dependencies: 
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library work;
use work.Constant_Package.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Top_Level_CPU is
    Port ( IN_PORT : in STD_LOGIC_VECTOR (15 downto 0);
           OUT_PORT : out STD_LOGIC_VECTOR (15 downto 0);
           clk_100MHz : in STD_LOGIC;
           reset_load : in STD_LOGIC;
           reset_execute : in STD_LOGIC
           );
end Top_Level_CPU;

architecture Behavioral of Top_Level_CPU is
--Component declaration
component Intruction_Fetch_Stage is
    Port ( 
          IR_IF_out : out STD_LOGIC_VECTOR (15 downto 0);
          NPC_IF_out : out STD_LOGIC_VECTOR (15 downto 0);
          clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          PC_in : in STD_LOGIC_VECTOR (15 downto 0);
          ram_addr_B : out std_logic_vector (15 downto 0);
          ram_data_B : in std_logic_vector (15 downto 0);
          halt : in STD_LOGIC;
          BR_IF_in : in STD_LOGIC;
          INPUT_IF_out: out std_logic_vector (15 downto 0);
          INPORT_IF_in: in std_logic_vector (15 downto 0));
end component Intruction_Fetch_Stage;
component Decode is
    Port ( 
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           IR_ID_in : in  STD_LOGIC_VECTOR (15 downto 0);
           NPC_ID_in : in  STD_LOGIC_VECTOR (15 downto 0);
           NPC_ID_out : out STD_LOGIC_VECTOR (15 downto 0);
           A_ID_out : out std_logic_vector(15 downto 0); 
           B_ID_out : out std_logic_vector(15 downto 0);
           IR_ID_out : out std_logic_vector(15 downto 0);
           wr_addr_ID_in : in std_logic_vector(2 downto 0);
           wr_data_ID_in : in std_logic_vector(15 downto 0);
           wr_enable_ID_in : in std_logic;
           --Overflow signals
           ov_data_ID_in : in std_logic_vector(15 downto 0);
           ov_enable_ID_in : in std_logic;
           loadIMM_ID_in: in std_logic;
           load_align_ID_in: in std_logic;
           INPUT_ID_in: in std_logic_vector(15 downto 0);
           halt : out std_logic;
           br_clear_in: in std_logic 
     );			  
end component Decode;

component EX_stage is
    Port (clk, rst: in STD_LOGIC;
           IR_EX_in: in std_logic_vector(15 downto 0);
           A_EX_in : in STD_LOGIC_VECTOR (15 downto 0);
           B_EX_in : in STD_LOGIC_VECTOR (15 downto 0);
           NPC_EX_in : in STD_LOGIC_VECTOR (15 downto 0);        
           Result_EX_out : out STD_LOGIC_VECTOR (15 downto 0);
           vdata_EX_out : out STD_LOGIC_VECTOR (15 downto 0);
           A_EX_out : out STD_LOGIC_VECTOR (15 downto 0);
           B_EX_out : out STD_LOGIC_VECTOR (15 downto 0);
           Z_EX_out : out std_logic;
           N_EX_out: out std_logic;
           IR_EX_out: out std_logic_vector(15 downto 0);
           NPC_EX_out : out std_logic_vector(15 downto 0);
           br_clear_in : in STD_LOGIC);
end component EX_stage;

component Memory_Stage is
    Port (clk, rst : in STD_LOGIC; 
            Result_MEM_in : in STD_LOGIC_VECTOR (15 downto 0);
            IR_MEM_in : in STD_LOGIC_VECTOR (15 downto 0);
            N_MEM_in : in STD_LOGIC;
            Z_MEM_in : in STD_LOGIC;
            branch : out STD_LOGIC;
            branch_addr : out STD_LOGIC_VECTOR (15 downto 0);
            pipe_flush : out std_logic;
            ram_wren_A: out std_logic;
            ram_en_A: out std_logic;
            ram_wrdata_A: out STD_LOGIC_VECTOR (15 downto 0);
            ram_addr_A: out std_logic_vector (15 downto 0);
            ram_data_A: in std_logic_vector (15 downto 0);
            memdata_MEM_out : out STD_LOGIC_VECTOR (15 downto 0);
            Result_MEM_out : out STD_LOGIC_VECTOR (15 downto 0);
            NPC_MEM_in : in STD_LOGIC_VECTOR (15 downto 0);
            IR_MEM_out : out STD_LOGIC_VECTOR (15 downto 0);
            vdata_MEM_in: in STD_LOGIC_VECTOR (15 downto 0); 
            A_MEM_in: in STD_LOGIC_VECTOR (15 downto 0); 
            B_MEM_in : in STD_LOGIC_VECTOR (15 downto 0);
            vdata_MEM_out : out STD_LOGIC_VECTOR (15 downto 0));
end component Memory_Stage;

component Write_Back_Stage is
    Port (clk, rst : in std_logic;
            Result_WB_in : in STD_LOGIC_VECTOR (15 downto 0);
            Overflow_in : in STD_LOGIC_VECTOR (15 downto 0);
            memdata_WB_in : in STD_LOGIC_VECTOR (15 downto 0);
            IR_WB_in : in STD_LOGIC_VECTOR (15 downto 0);
            IN_PORT : in STD_LOGIC_VECTOR (15 downto 0);
            wr_data_WB_out : out STD_LOGIC_VECTOR (15 downto 0);
            wr_addr_WB_out : out STD_LOGIC_VECTOR (2 downto 0);
            wr_enable_WB_out : out std_logic;
            ov_en_WB_out : out std_logic;
            loadIMM_WB_out: out std_logic;
            load_align_WB_out: out std_logic;
            ov_data_WB_out : out STD_LOGIC_VECTOR (15 downto 0));
end component Write_Back_Stage;

component RAM is
    Port (  clk, rst : in std_logic;
            douta : out STD_LOGIC_VECTOR (15 downto 0);
            doutb : out STD_LOGIC_VECTOR (15 downto 0);
            addra : in std_logic_vector (15 downto 0);
            addrb : in std_logic_vector (15 downto 0);
            dina : in std_logic_vector (15 downto 0);
            wr_en : in std_logic;
            ena : in std_logic;
            enb : in std_logic);
end component RAM;




component  ForwardingUnit is
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
            Result_WB_inF: in STD_LOGIC_VECTOR (15 downto 0)
       );
         
end component ForwardingUnit;
--clk rst
signal clk, rst : std_logic := '0';

--Intermediate Signals
signal IF_ID_IR, ID_EX_IR, EX_MEM_IR,  MEM_WB_IR: std_logic_vector(15 downto 0);
signal WB_ID_wr_data, WB_ID_v_data, ID_EX_A, ID_EX_B: std_logic_vector(15 downto 0);
signal EX_MEM_alu_res, EX_MEM_v_data, MEM_WB_mem_data, MEM_WB_alu, MEM_WB_v_data, EX_MEM_A, EX_MEM_B : std_logic_vector(15 downto 0);
signal IF_ID_NPC, IF_ID_INPUT, WB_IF_PC, ID_EX_NPC, MEM_IF_br_addr, EX_MEM_NPC : std_logic_vector(15 downto 0);
signal MEM_IF_br, WB_ID_wr_en, WB_ID_v_en, EX_MEM_N_flag, EX_MEM_Z_flag, MEM_pipe_flush : std_logic;
signal WB_ID_wr_addr : std_logic_vector(2 downto 0);
signal WB_ID_loadimm, WB_ID_load_align: std_logic;

--Forwarding Unit
 --ID_A_outF, ID_B_out,  EX_alu_res: std_logic_vector(15 downto 0);
 signal FU_EX_A, FU_EX_B,  MEM_alu_res: std_logic_vector(15 downto 0);
 
 
--RAM intermediate Signals
signal ram_addra, ram_addrb : std_logic_vector(15 downto 0);
signal ram_dataa, ram_datab, ram_dina : std_logic_vector(15 downto 0);
signal ram_wr_en, ram_ena, ram_enb, out_en : std_logic;

-- Halt for RAW
signal halt : std_logic := '0';

begin
IF_inst : Intruction_Fetch_Stage port map(
        clk=>clk, 
        rst=>rst, 
        halt=>halt,
        IR_IF_out=>IF_ID_IR, 
        NPC_IF_out=>IF_ID_NPC, 
        PC_in=>MEM_IF_br_addr, 
        ram_addr_B=>ram_addrb, 
        ram_data_B=>ram_datab, 
        BR_IF_in=>MEM_IF_br,
        INPORT_IF_in =>IN_PORT,
        INPUT_IF_out => IF_ID_INPUT

);
                                            
                                            
ID_inst : Decode port map(
clk=>clk, 
rst=>rst,
br_clear_in=>MEM_pipe_flush,
halt => halt, 
IR_ID_in=>IF_ID_IR, 
wr_addr_ID_in=>WB_ID_wr_addr, 
wr_data_ID_in=>WB_ID_wr_data, 
wr_enable_ID_in=>WB_ID_wr_en, 
ov_data_ID_in=>WB_ID_v_data, 
ov_enable_ID_in=>WB_ID_v_en, 
A_ID_out=>ID_EX_A, 
B_ID_out=>ID_EX_B, 
IR_ID_out=>ID_EX_IR,
loadIMM_ID_in=>WB_ID_loadimm, 
load_align_ID_in=> WB_ID_load_align, 
NPC_ID_out=>ID_EX_NPC, 
NPC_ID_in=>IF_ID_NPC,
INPUT_ID_in =>IF_ID_INPUT
 
);

EX_inst : EX_stage port map(
clk=>clk, 
rst=>MEM_pipe_flush, 
IR_EX_in=>ID_EX_IR, 
A_EX_in=>FU_EX_A, 
B_EX_in=>FU_EX_B, 
Result_EX_out=>EX_MEM_alu_res, 
vdata_EX_out=>EX_MEM_v_data,
Z_EX_out=>EX_MEM_Z_flag, 
N_EX_out=>EX_MEM_N_flag, 
IR_EX_out=>EX_MEM_IR, 
A_EX_out =>EX_MEM_A,
B_EX_out =>EX_MEM_B, 
NPC_EX_in=>ID_EX_NPC, 
NPC_EX_out=>EX_MEM_NPC,
br_clear_in=>MEM_pipe_flush);


MEM_inst : Memory_Stage port map(
clk=>clk, 
rst=>rst, 
Result_MEM_in=>EX_MEM_alu_res, 
IR_MEM_in=>EX_MEM_IR, 
N_MEM_in=>EX_MEM_N_flag, 
Z_MEM_in=>EX_MEM_Z_flag, 
branch=>MEM_IF_br, 
branch_addr=>MEM_IF_br_addr,  
ram_wren_A=>ram_wr_en,
ram_addr_A=>ram_addra, 
NPC_MEM_in=>EX_MEM_NPC, 
ram_data_A=>ram_dataa, 
ram_wrdata_A=>ram_dina, 
ram_en_A=>ram_ena, 
memdata_MEM_out=>MEM_WB_mem_data, 
Result_MEM_out=>MEM_WB_alu, 
IR_MEM_out=>MEM_WB_IR, 
vdata_MEM_in=>EX_MEM_v_data,
 A_MEM_in=>EX_MEM_A, B_MEM_in=>EX_MEM_B,
 vdata_MEM_out=>MEM_WB_v_data, 
 pipe_flush=>MEM_pipe_flush);

WB_inst : Write_Back_Stage port map(
clk=>clk, 
rst=>rst, 
Result_WB_in=>MEM_WB_alu, 
Overflow_in=>MEM_WB_v_data,
 memdata_WB_in=>MEM_WB_mem_data, 
IR_WB_in=>MEM_WB_IR, 
IN_PORT=>IN_PORT, 
wr_data_WB_out=>WB_ID_wr_data,
 wr_addr_WB_out=>WB_ID_wr_addr, 
wr_enable_WB_out=>WB_ID_wr_en, 
ov_en_WB_out=>WB_ID_v_en, 
loadIMM_WB_out=>WB_ID_loadimm, 
load_align_WB_out=> WB_ID_load_align, 
ov_data_WB_out=>WB_ID_v_data);


RAM_inst : RAM port map (
douta=>ram_dataa, 
doutb=>ram_datab, 
addra=>ram_addra, 
addrb=>ram_addrb, 
dina=>ram_dina,
 wr_en=>ram_wr_en, 
ena=>ram_ena, 
enb=>ram_enb, 
clk=>clk, 
rst=>rst);

ForwardUnit_inst : ForwardingUnit port map(
clk=>clk, 
rst=>rst,
IR_EX_inF =>ID_EX_IR,
IR_MEM_inF =>EX_MEM_IR,
IR_WB_inF => MEM_WB_IR,
A_EX_inF=>FU_EX_A,
B_EX_inF=> FU_EX_B,
A_ID_outF => ID_EX_A,
B_ID_outF => ID_EX_B,
A_MEM_inF=> EX_MEM_A,
B_MEM_inF=> EX_MEM_B,
Result_MEM_inF => EX_MEM_alu_res,
Result_WB_inF => MEM_WB_ALU
);


--TODO: Control RAM enable signal somewhere else
ram_enb <= '1';
--TODO: Need to Update the reset sequence
rst <= reset_load or reset_execute;

--Grab Clock from Board
clk <= clk_100MHz;



end Behavioral;
