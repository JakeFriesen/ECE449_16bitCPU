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
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decode is
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
			  halt : out std_logic;
			  br_clear_in: in std_logic 
	    );			  
end Decode;

architecture Behavioral of Decode is

component register_file is
    port(rst : in std_logic; clk: in std_logic;
    --read signals
    rd_index1: in std_logic_vector(2 downto 0); 
    rd_index2: in std_logic_vector(2 downto 0); 
    rd_data1: out std_logic_vector(15 downto 0); 
    rd_data2: out std_logic_vector(15 downto 0);
    --write signals
    wr_addr: in std_logic_vector(2 downto 0); 
    wr_data: in std_logic_vector(15 downto 0); 
    wr_enable: in std_logic;
    --overflow signals
    ov_data: in std_logic_vector(15 downto 0);
    loadIMM: in std_logic;
    load_align: in std_logic;
    ov_enable: in std_logic
    );
end component register_file;

component RAW is
    port(
            rst : in std_logic;
            clk : in std_logic;
            wr_en : in std_logic;
            IR_wb : in std_logic;
            ra_index : in std_logic_vector(2 downto 0);
            wr_addr : in std_logic_vector(2 downto 0);
            rd_index1 : in std_logic_vector(2 downto 0);
            rd_index2 : in std_logic_vector(2 downto 0);
            rd_enable : in std_logic;
            halt : out std_logic
         );
end component RAW;

component MUX2_1 is
    Port ( x : in STD_LOGIC_VECTOR (15 downto 0);
           y : in STD_LOGIC_VECTOR (15 downto 0);
           s : in STD_LOGIC;
           z : out STD_LOGIC_VECTOR (15 downto 0));
end component MUX2_1;

component Stack_Register is
    Port ( SP_in : in STD_LOGIC_VECTOR (15 downto 0);
           SP_out : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           IR_in : in STD_LOGIC_VECTOR (15 downto 0));
end component;

--Signals
signal npc : std_logic_vector (15 downto 0);
signal ra_index, rd_index1_intern, rd_index2_intern : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
signal output_en, halt_intern, IR_wb, rd_enable : STD_LOGIC := '0';
signal rd_data1_out, rd_data2_out, IR_intrn, A_internal, B_internal, B_data, outport_internal, outport_previous : std_logic_vector(15 downto 0) := (others=>'0');
signal stack_pointer : std_logic_vector (15 downto 0);
-- Constant X"0000"
constant zero : std_logic_vector(15 downto 0) := X"0000";


begin
--Stack Register
stack_reg : Stack_Register port map (
    clk=>clk,
    rst=>rst,
    IR_in=>IR_intrn,
    SP_in=>A_internal,
    SP_out=>stack_pointer
);                    
-- RAW
raw_handler : RAW port map(
    rst=>rst, 
    clk=>clk, 
    wr_en=>wr_enable_ID_in, 
    IR_wb=>IR_wb, 
    ra_index=>ra_index,
    wr_addr=>wr_addr_ID_in, 
    rd_index1=>rd_index1_intern, 
    rd_index2=>rd_index2_intern, 
    halt=>halt_intern, 
    rd_enable=>rd_enable);
--reg file
reg_file : register_file port map(
    rst => rst, 
    clk => clk, 
    rd_index1 => rd_index1_intern, 
    rd_index2 => rd_index2_intern, 
    rd_data1 => rd_data1_out, 
    rd_data2 => rd_data2_out, 
    wr_addr => wr_addr_ID_in,
    wr_data => wr_data_ID_in, 
    wr_enable => wr_enable_ID_in, 
    ov_data => ov_data_ID_in,
    loadIMM=>loadIMM_ID_in,
    load_align => load_align_ID_in, 
    ov_enable => ov_enable_ID_in
);

ra_index <= "111" when IR_intrn(15 downto 9) = loadIMM_op else
            IR_intrn(8 downto 6);
    
with IR_intrn(15 downto 9) select
	IR_wb <= 
		'1' when add_op | sub_op | mul_op | nand_op | shl_op | shr_op | in_op | loadIMM_op | pop_op | mov_op,
		'0' when others;

--select read index 1 & 2 for regfile	
with IR_intrn(15 downto 9) select
	rd_index1_intern <= IR_intrn(5 downto 3) when add_op | sub_op | mul_op | mov_op | load_op,
						IR_intrn(8 downto 6) when nand_op | shl_op | shr_op | test_op | out_op | br_op | 
						                          br_n_op | br_z_op | br_sub_op | store_op,
						"111" when return_op,
						"000" when others;	
						
with IR_intrn(15 downto 9) select	
	rd_index2_intern <= IR_intrn(2 downto 0) when add_op | sub_op | mul_op,
	                    IR_intrn(5 downto 3) when nand_op | store_op,
	                    IR_intrn(8 downto 6) when load_sp_op | push_op | pop_op,
	                    "000" when others;
with IR_intrn(15 downto 9) select	
    rd_enable <= '1' when add_op | sub_op | mul_op | nand_op | shl_op | shr_op | test_op | out_op | mov_op | store_op | push_op,
                 '0' when others;


--MUX assignments--
--m1 : MUX2_1 port map(
--    x => rd_data1_out, 
--    y => zero, 
--    s => output_en, 
--    z => A_internal
--);
--TODO: Forwarding from wr_data_ID_in to A/B_internal when possible

--Push the stack pointer into B when PUSH, POP, or RTI
B_internal <= rd_data2_out;
A_internal <= stack_pointer when IR_intrn(15 downto 9) = push_op else
              stack_pointer when IR_intrn(15 downto 9) = rti_op else
              rd_data1_out;

halt <= halt_intern;


	--latching		
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1' or br_clear_in = '1') then
				IR_intrn <= zero;
				npc <= (others=>'0');
			else
			    IR_intrn <= IR_ID_in;
				npc <= NPC_ID_in;
                outport_previous <= outport_internal;
			end if;
		end if;
		--Latch Output Signals
		if falling_edge(clk) then
		  if(rst = '1') then
		      A_ID_out <= (others=>'0');
		      B_ID_out <= (others=>'0');
		      NPC_ID_out <= (others=>'0');
		      IR_ID_out <= (others=>'0');
		  	elsif (halt_intern='0') then
		      A_ID_out <= A_internal;
		      B_ID_out <= B_internal;
		      IR_ID_out <= IR_intrn;
		      NPC_ID_out <= npc;
			elsif (halt_intern='1') then
		      A_ID_out <= (others=>'0');
		      B_ID_out <= (others=>'0');
		      IR_ID_out <= (others=>'0');
			  NPC_ID_out <= npc;
		  end if;
		end if;
	end process;

end Behavioral;
