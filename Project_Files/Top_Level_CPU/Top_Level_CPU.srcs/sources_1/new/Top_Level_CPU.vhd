----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2023 03:46:22 PM
-- Design Name: 
-- Module Name: Top_Level_CPU - Behavioral
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
    Port ( IR : out STD_LOGIC_VECTOR (15 downto 0);
           NPC : out STD_LOGIC_VECTOR (5 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           PC_in : in STD_LOGIC_VECTOR (5 downto 0);
           ram_addr : out std_logic_vector (5 downto 0);
           ram_data : in std_logic_vector (15 downto 0);
           br_in : in STD_LOGIC);
end component Intruction_Fetch_Stage;
component Decode is
    Port ( 
          rst : in STD_LOGIC;
          clk : in STD_LOGIC;
          IR : in  STD_LOGIC_VECTOR (15 downto 0);
          --npc_in : in  STD_LOGIC_VECTOR (15 downto 0);
          --npc_out : out STD_LOGIC_VECTOR (15 downto 0);
          A : out std_logic_vector(15 downto 0); 
          B : out std_logic_vector(15 downto 0);
          IR_out : out std_logic_vector(15 downto 0);
          wr_index : in std_logic_vector(2 downto 0);
          wr_data : in std_logic_vector(15 downto 0);
          wr_enable : in std_logic;
          ov_data : in std_logic_vector(15 downto 0);
          ov_enable : in std_logic;
          outport : out std_logic_vector(15 downto 0)
	    );			  
end component Decode;
component EX_stage is
       Port ( 
       clk: in STD_LOGIC;
       rst: in STD_LOGIC;
       I_IR: in std_logic_vector(15 downto 0);
       I_A : in STD_LOGIC_VECTOR (15 downto 0);
       I_B : in STD_LOGIC_VECTOR (15 downto 0);
--           INPUT: in STD_LOGIC_VECTOR(15 downto 0);
               
       O_result : out STD_LOGIC_VECTOR (15 downto 0);
       O_Vdata : out STD_LOGIC_VECTOR (15 downto 0);
       O_A : out STD_LOGIC_VECTOR (15 downto 0);
       O_B : out STD_LOGIC_VECTOR (15 downto 0);
     --  O_Z : out STD_LOGIC;
      -- O_N : out STD_LOGIC;
     --  O_V : out STD_LOGIC;
    --   O_V_EN: out STD_LOGIC; 
       O_Z_OUTPUT : out std_logic;
       O_N_OUTPUT: out std_logic;
--           O_OUTPUT: out std_logic_vector(15 downto 0);
       O_IR: out std_logic_vector(15 downto 0));
end component EX_stage;
component Memory_Stage is
   Port ( ALU_in : in STD_LOGIC_VECTOR (15 downto 0);
        IR_in : in STD_LOGIC_VECTOR (15 downto 0);
        N : in STD_LOGIC;
        Z : in STD_LOGIC;
        clk, rst : in STD_LOGIC;
        branch : out STD_LOGIC;
        branch_addr : out STD_LOGIC_VECTOR (5 downto 0);
        Mem_wr: out std_logic;
        Mem_en: out std_logic;
        Mem_in: out STD_LOGIC_VECTOR (15 downto 0);
        Mem_addr: out std_logic_vector (5 downto 0);
        Ram_out: in std_logic_vector (15 downto 0);
        Mem_out : out STD_LOGIC_VECTOR (15 downto 0);
        ALU_out : out STD_LOGIC_VECTOR (15 downto 0);
        IR_out : out STD_LOGIC_VECTOR (15 downto 0);
        Overflow_in, A_in, B_in : in STD_LOGIC_VECTOR (15 downto 0);
        Overflow_out : out STD_LOGIC_VECTOR (15 downto 0));
end component Memory_Stage;
component Write_Back_Stage is
    Port ( clk, rst : in std_logic;
           ALU_in : in STD_LOGIC_VECTOR (15 downto 0);
           Overflow_in : in STD_LOGIC_VECTOR (15 downto 0);
           Mem_in : in STD_LOGIC_VECTOR (15 downto 0);
           IR_in : in STD_LOGIC_VECTOR (15 downto 0);
           IN_PORT : in STD_LOGIC_VECTOR (15 downto 0);
           wr_data : out STD_LOGIC_VECTOR (15 downto 0);
           wr_addr : out STD_LOGIC_VECTOR (2 downto 0);
           wr_en : out std_logic;
           v_en : out std_logic;
           V_data : out STD_LOGIC_VECTOR (15 downto 0));
end component Write_Back_Stage;
component RAM is
    Port ( douta : out STD_LOGIC_VECTOR (15 downto 0);
           doutb : out STD_LOGIC_VECTOR (15 downto 0);
           addra : in std_logic_vector (5 downto 0);
           addrb : in std_logic_vector (5 downto 0);
           dina : in std_logic_vector (15 downto 0);
           wr_en : in std_logic;
           ena : in std_logic;
           enb : in std_logic;
           clk : in std_logic;
           rst : in std_logic);
           
end component RAM;
--clk rst
signal clk, rst : std_logic := '0';
--Intermediate Signals
signal IF_ID_IR, WB_ID_wr_data, WB_ID_v_data, ID_EX_A, ID_EX_B, ID_EX_IR, EX_MEM_IR, EX_MEM_alu_res, EX_MEM_v_data, MEM_WB_mem_data, MEM_WB_alu, MEM_WB_v_data, MEM_WB_IR, EX_MEM_A, EX_MEM_B : std_logic_vector(15 downto 0);
signal IF_ID_NPC, WB_IF_PC, ID_EX_NPC, MEM_IF_br_addr : std_logic_vector(5 downto 0);
signal MEM_IF_br, WB_ID_wr_en, WB_ID_v_en, EX_MEM_N_flag, EX_MEM_Z_flag : std_logic;
signal WB_ID_wr_addr : std_logic_vector(2 downto 0);
signal R7_align: std_logic;

--RAM signals
signal ram_addra, ram_addrb : std_logic_vector(5 downto 0);
signal ram_dataa, ram_datab, ram_dina, Overflow : std_logic_vector(15 downto 0);
signal ram_wr_en, ram_ena, ram_enb, out_en : std_logic;

begin
IF_inst : Intruction_Fetch_Stage port map(clk=>clk, rst=>rst, IR=>IF_ID_IR, NPC=>IF_ID_NPC, PC_in=>MEM_IF_br_addr, ram_addr=>ram_addrb, ram_data=>ram_datab, br_in=>MEM_IF_br);

ID_inst : Decode port map(clk=>clk, rst=>rst, IR=>IF_ID_IR, wr_index=>WB_ID_wr_addr, wr_data=>WB_ID_wr_data, wr_enable=>WB_ID_wr_en, ov_data=>WB_ID_v_data, ov_enable=>WB_ID_v_en, A=>ID_EX_A, B=>ID_EX_B, IR_out=>ID_EX_IR, outport=>OUT_PORT);

EX_inst : EX_stage port map(clk=>clk, rst=>rst, I_IR=>ID_EX_IR, I_A=>ID_EX_A, I_B=>ID_EX_B, O_result=>EX_MEM_alu_res, O_vdata=>EX_MEM_v_data, O_Z_OUTPUT=>EX_MEM_Z_flag, O_N_OUTPUT=>EX_MEM_N_flag, O_IR=>EX_MEM_IR, O_A =>EX_MEM_A, O_B =>EX_MEM_B);


MEM_inst : Memory_Stage port map(clk=>clk, rst=>rst, ALU_in=>EX_MEM_alu_res, IR_in=>EX_MEM_IR, N=>EX_MEM_N_flag, Z=>EX_MEM_Z_flag, branch=>MEM_IF_br, branch_addr=>MEM_IF_br_addr,  Mem_wr=>ram_wr_en,Mem_addr=>ram_addra, 
                                 ram_out=>ram_dataa, Mem_in=>ram_dina, Mem_en=>ram_ena, Mem_out=>MEM_WB_mem_data, ALU_out=>MEM_WB_alu, IR_out=>MEM_WB_IR, Overflow_in=>EX_MEM_v_data, A_in=>EX_MEM_A, B_in=>EX_MEM_B, Overflow_out=>MEM_WB_v_data);

WB_inst : Write_Back_Stage port map(clk=>clk, rst=>rst, ALU_in=>MEM_WB_alu, Overflow_in=>MEM_WB_v_data, Mem_in=>MEM_WB_mem_data, IR_in=>MEM_WB_IR, IN_PORT=>IN_PORT, wr_data=>WB_ID_wr_data, wr_addr=>WB_ID_wr_addr, wr_en=>WB_ID_wr_en, v_en=>WB_ID_v_en, V_data=>WB_ID_v_data);


RAM_inst : RAM port map (douta=>ram_dataa, doutb=>ram_datab, addra=>ram_addra, addrb=>ram_addrb, dina=>ram_dina, wr_en=>ram_wr_en, ena=>ram_ena, enb=>ram_enb, clk=>clk, rst=>rst);

--TODO: Control RAM enable signal somewhere else
--ram_ena <= '1';
ram_enb <= '1';
--TODO: Need to Update the reset sequence
rst <= reset_load or reset_execute;

--Grab Clock from Board
clk <= clk_100MHz;



end Behavioral;
