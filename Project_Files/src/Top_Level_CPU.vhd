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
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Top_Level_CPU is
    Port ( IN_PORT : in STD_LOGIC_VECTOR (15 downto 0);
           OUT_PORT : out STD_LOGIC_VECTOR (15 downto 0);
           OUT_BOOT : out STD_LOGIC;
           sseg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           clk_100MHz : in STD_LOGIC;
           reset_load : in STD_LOGIC;
           reset_execute : in STD_LOGIC;
           mode_sel : in STD_LOGIC;
           seg_sel : in STD_LOGIC_VECTOR (4 downto 0);
           sys_rst : in STD_LOGIC;
           clk_in : in STD_LOGIC
           );
end Top_Level_CPU;

architecture Behavioral of Top_Level_CPU is
--Component declaration
component display_controller is
	port(
		clk, reset: in std_logic;
		hex3, hex2, hex1, hex0: in std_logic_vector(3 downto 0);
		an: out std_logic_vector(3 downto 0);
		sseg: out std_logic_vector(6 downto 0)
	);
end component display_controller;
component my_D_FF is
    Port ( clock_100MHz : in  STD_LOGIC;
           reset        : in  STD_LOGIC;
           Q            : out STD_LOGIC);
end component my_D_FF;
component Intruction_Fetch_Stage is
    Port ( clk, halt : in STD_LOGIC;
           reset_load : in STD_LOGIC;
           reset_execute : in STD_LOGIC;
           IR_IF_out : out STD_LOGIC_VECTOR (15 downto 0);
           NPC_IF_out : out STD_LOGIC_VECTOR (15 downto 0);
           PC_in : in STD_LOGIC_VECTOR (15 downto 0);
           ram_addr_B : out std_logic_vector (15 downto 0);
           ram_data_B : in std_logic_vector (15 downto 0);
           new_counter : out std_logic_vector(15 downto 0);
           INPUT_IF_out: out std_logic_vector (15 downto 0);
           INPORT_IF_in: in std_logic_vector (15 downto 0);
           BR_IF_in : in STD_LOGIC);
end component Intruction_Fetch_Stage;
component Decode is
    Port ( 
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           halt : in STD_LOGIC;
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
           R7_data_ID_out: out std_logic_vector(15 downto 0); 
           loadIMM_ID_in: in std_logic;
           load_align_ID_in: in std_logic;
           INPUT_ID_in: in std_logic_vector(15 downto 0); 
           --debug
           reg_file_out_debug: out reg_array;
           br_clear_in: in std_logic 
     );			  
end component Decode;

component EX_stage is
    Port (clk, rst, halt: in STD_LOGIC;
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
            OUT_PORT : out STD_LOGIC_VECTOR (15 downto 0);
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
component ROM is
    Port ( addr : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in std_logic;
           rst : in std_logic;
           en : in std_logic;
           data : out STD_LOGIC_VECTOR (15 downto 0));
end component ROM;

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
            Result_WB_inF: in STD_LOGIC_VECTOR (15 downto 0);
            Memdata_WB_inF: in STD_LOGIC_VECTOR (15 downto 0);
            Write_data_inF: in STD_LOGIC_VECTOR (15 downto 0);
            Write_addr_inF: in STD_LOGIC_VECTOR (2 downto 0);
            Write_en_inF: in STD_LOGIC;
            loadIMM_inF: in std_logic;
            R7_data_inF: in std_logic_vector(15 downto 0); 
            halt: out std_logic
       );
         
end component ForwardingUnit;
--clk rst
signal clk, rst : std_logic := '0';

--Intermediate Signals
signal IF_ID_IR, ID_EX_IR, EX_MEM_IR,  MEM_WB_IR: std_logic_vector(15 downto 0);
signal WB_ID_wr_data, WB_ID_v_data, ID_EX_A, ID_EX_B: std_logic_vector(15 downto 0);
signal EX_MEM_alu_res, EX_MEM_v_data, MEM_WB_mem_data, MEM_WB_alu, MEM_WB_v_data, EX_MEM_A, EX_MEM_B, R7_data : std_logic_vector(15 downto 0);
signal IF_ID_NPC, IF_ID_INPUT, WB_IF_PC, ID_EX_NPC, MEM_IF_br_addr, EX_MEM_NPC : std_logic_vector(15 downto 0);
signal MEM_IF_br, WB_ID_wr_en, WB_ID_v_en, EX_MEM_N_flag, EX_MEM_Z_flag, MEM_pipe_flush : std_logic;
signal WB_ID_wr_addr : std_logic_vector(2 downto 0);
signal WB_ID_loadimm, WB_ID_load_align: std_logic;
signal input_internal, out_internal, seven_seg_binary : std_logic_vector(15 downto 0);

--RAM, ROM intermediate Signals
signal ram_addra, ram_addrb, mem_addrb, mem_addra: std_logic_vector(15 downto 0);
signal ram_dataa, ram_datab, mem_datab, ram_dina, rom_addr, rom_data : std_logic_vector(15 downto 0);
signal ram_wr_en, ram_ena, ram_enb, out_en, rom_en : std_logic;
signal program_out : std_logic_vector (15 downto 0);
--Forwarding Unit
--ID_A_outF, ID_B_out,  EX_alu_res: std_logic_vector(15 downto 0);
signal FU_EX_A, FU_EX_B,  MEM_alu_res: std_logic_vector(15 downto 0);
signal reg_file_out_debug_internal : reg_array;
signal clk_sseg : std_logic;
-- Halt for RAW
signal halt : std_logic := '0';

begin
clk_divider : my_D_FF port map(
    clock_100Mhz => clk_100MHz,
    reset => sys_rst,
    Q => clk_sseg
);
clk <= clk_in;

disp_cont : display_controller port map(
    clk => clk_sseg,
    reset => rst,
    hex3 => seven_seg_binary(15 downto 12),
    hex2 => seven_seg_binary(11 downto 8),
    hex1 =>seven_seg_binary(7 downto 4),
    hex0 =>seven_seg_binary(3 downto 0),
    an => an,
    sseg => sseg
);

IF_inst : Intruction_Fetch_Stage port map(
    new_counter => program_out,
    clk=>clk, 
    reset_load => reset_load,
    reset_execute => reset_execute,
    halt=>halt,
    IR_IF_out=>IF_ID_IR, 
    NPC_IF_out=>IF_ID_NPC, 
    PC_in=>MEM_IF_br_addr, 
    ram_addr_B=>mem_addrb, 
    ram_data_B=>mem_datab, 
    INPORT_IF_in =>input_internal,
    INPUT_IF_out => IF_ID_INPUT,
    BR_IF_in=>MEM_IF_br
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
INPUT_ID_in =>IF_ID_INPUT,
reg_file_out_debug => reg_file_out_debug_internal,
R7_data_ID_out => R7_data
 
);

EX_inst : EX_stage port map(
clk=>clk, 
rst=>MEM_pipe_flush, 
halt => halt,
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
ram_addr_A=>mem_addra, 
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
wr_data_WB_out=>WB_ID_wr_data,
 wr_addr_WB_out=>WB_ID_wr_addr, 
wr_enable_WB_out=>WB_ID_wr_en, 
ov_en_WB_out=>WB_ID_v_en, 
loadIMM_WB_out=>WB_ID_loadimm, 
load_align_WB_out=> WB_ID_load_align, 
OUT_PORT => out_internal,
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
    rst=>sys_rst
);
ROM_inst : ROM port map (
    addr => rom_addr,
    clk => clk,
    rst => sys_rst,
    en => rom_en,
    data => rom_data
);

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
Result_WB_inF => MEM_WB_ALU,
Memdata_WB_inF =>MEM_WB_mem_data,
Write_data_inF => WB_ID_wr_data,
Write_addr_inF =>WB_ID_wr_addr,
Write_en_inF => WB_ID_wr_en,
loadIMM_inF=>WB_ID_loadimm,
R7_data_inF => R7_data,
halt => halt
);



rst <= reset_load or reset_execute or sys_rst;
-- RAM(0x0400-0x07FF) and ROM(0x0000-0x03FF) addressing
-- downto 1 because ROM/RAM are word addressed
rom_addr <= "0000000" & mem_addrb(9 downto 1);
ram_addrb <= "0000000" & mem_addrb(9 downto 1);
-- Switch on 10th bit 
ram_enb <='1';-- mem_addrb(10);
rom_en <= not mem_addrb(10);
-- RAM and ROM data
--UNCOMMENT WHEN NOT TESTING
mem_datab <= ram_datab when mem_addrb(10) = '1' else
            rom_data;

ram_addra <= "0000000" & mem_addra(9 downto 1);

--Input Output Routing
input_internal <= "0000000000" & IN_PORT(5 downto 0) when mode_sel = '0' else
                  IN_PORT(15 downto 6) & "000000";
OUT_BOOT <= out_internal(0);
OUT_PORT <= out_internal ;

--seven_seg_binary  <= IF_ID_NPC;

seven_seg_binary <= IF_ID_NPC when seg_sel = "0000" else
            IF_ID_IR when seg_sel = "0001" else
            out_internal when seg_sel = "0010" else
            input_internal when seg_sel = "0011" else
            reg_file_out_debug_internal(to_integer(unsigned(seg_sel(2 downto 0)))) when seg_sel(3) = '1' else
            (others=>'0');

end Behavioral;
