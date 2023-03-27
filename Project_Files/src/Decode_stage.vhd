---------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Course: University of Victoria
-- Engineer: Jake Friesen, Matthew Ebert, Samuel Pacheo 
-- 
-- Create Date: 2023-Mar-09

-- Module Name: Decode_Stage - Behavioral
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
use ieee.std_logic_unsigned.all;


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decode is
    Port ( 
			  rst : in STD_LOGIC;
			  clk : in STD_LOGIC;
			  Z_ID_in : in STD_LOGIC;
			  N_ID_in : in STD_LOGIC;
			  IR_ID_in : in  STD_LOGIC_VECTOR (15 downto 0);
			  NPC_ID_in : in  STD_LOGIC_VECTOR (15 downto 0);
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
			  branch_ID_out : out std_logic;
			  branch_addr_ID_out : out std_logic_vector(15 downto 0);
			  pipe_flush_ID_out : out std_logic
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

component Stack_Register is
    Port ( SP_in : in STD_LOGIC_VECTOR (15 downto 0);
           SP_out : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           halt : in STD_LOGIC;
           IR_in : in STD_LOGIC_VECTOR (15 downto 0));
end component;

--Signals
signal ra_index, rd_index1_intern, rd_index2_intern : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
signal output_en, halt_intern, IR_wb, rd_enable, N_intrn, Z_intrn, branch_intrn : STD_LOGIC := '0';
signal stack_pointer, rd_data1_out, rd_data2_out, IR_intrn, IR_out_internal, A_internal, B_internal, B_data, ADDER_A, ADDER_B, NPC : std_logic_vector(15 downto 0) := (others=>'0');
signal OPCODE : std_logic_vector (6 downto 0) := (others=>'0');

begin
--Stack Register
stack_reg : Stack_Register port map (
    clk=>clk,
    rst=>rst,
    halt=>halt_intern,
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

ra_index <= "111" when OPCODE = loadIMM_op else
            IR_intrn(8 downto 6);
    
with OPCODE select
	IR_wb <= 
		'1' when add_op | sub_op | mul_op | nand_op | shl_op | shr_op | in_op | loadIMM_op | pop_op | mov_op,
		'0' when others;

--select read index 1 & 2 for regfile	
with OPCODE select
	rd_index1_intern <= IR_intrn(5 downto 3) when add_op | sub_op | mul_op | mov_op | load_op,
						IR_intrn(8 downto 6) when nand_op | shl_op | shr_op | test_op | out_op | br_op | 
						                          br_n_op | br_z_op | br_sub_op | store_op,
						"111" when return_op,
						"000" when others;	
						
with OPCODE select	
	rd_index2_intern <= IR_intrn(2 downto 0) when add_op | sub_op | mul_op,
	                    IR_intrn(5 downto 3) when nand_op | store_op,
	                    IR_intrn(8 downto 6) when load_sp_op | push_op | pop_op,
	                    "000" when others;
with OPCODE select	
    rd_enable <= '1' when add_op | sub_op | mul_op | nand_op | shl_op | shr_op | test_op | out_op | mov_op | store_op | push_op,
                 '0' when others;

--TODO: Forwarding from wr_data_ID_in to A/B_internal when possible

--Push the stack pointer into B when PUSH, POP, or RTI
B_internal <= 
              (others=>'0') when halt_intern = '1' else
              rd_data2_out;
A_internal <= 
              (others=>'0') when halt_intern = '1' else
              stack_pointer when OPCODE = pop_op else
              stack_pointer when OPCODE = push_op else
              stack_pointer when OPCODE = rti_op else
              rd_data1_out;
              
IR_out_internal <= (others=>'0') when halt_intern = '1' else
                   IR_intrn;

halt <= halt_intern;

-- Choose ADDER_B
with OPCODE select
    ADDER_A <= NPC when brr_op | brr_n_op | brr_z_op,
               A_internal when br_op | br_n_op | br_z_op | br_sub_op | return_op,
               X"0000" when others;
               
-- Choose ADDER_B
process(OPCODE)
begin
case OPCODE is
    when brr_op | brr_n_op | brr_z_op =>
        --Sign Extend the Immediate value
        if(IR_intrn(8) = '0') then
            ADDER_B <= "0000000" & IR_intrn(8 downto 0);
        else
            ADDER_B <= "1111111" & IR_intrn(8 downto 0);
        end if;
    when br_op | br_n_op | br_z_op | br_sub_op =>
        --Sign Extend the Immediate value
        if(IR_intrn(5) = '0') then
            ADDER_B <= "0000000000" & IR_intrn(5 downto 0);
        else
            ADDER_B <= "1111111111" & IR_intrn(5 downto 0);
        end if;
    when others =>
        ADDER_B <= (others=>'0');
    end case;
end process;

--Branch Choice
    process(OPCODE)
    begin
        case(OPCODE) is
            when brr_op | br_op | br_sub_op | return_op => --TODO: return_op
                branch_intrn <= '1';
                branch_addr_ID_out <= ADDER_A + ADDER_B;
            when brr_n_op | br_n_op =>
                if(N_intrn = '1') then
                    branch_intrn <= '1';
                    branch_addr_ID_out <= ADDER_A + ADDER_B;
                else
                    branch_intrn <= '0';
                    branch_addr_ID_out <= (others => '0'); 
                end if;
            when brr_z_op | br_z_op =>
                if(Z_intrn = '1') then
                    branch_intrn <= '1';
                    branch_addr_ID_out <= ADDER_A + ADDER_B;
                else
                    branch_intrn <= '0';
                    branch_addr_ID_out <= (others => '0'); 
                end if;
            when others =>
                branch_intrn <= '0';
                branch_addr_ID_out <= (others => '0');            
        end case;    
    end process;

    -- Latching		
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1' or branch_intrn = '1') then
				IR_intrn <= (others=>'0');
				OPCODE <= (others=>'0');
				npc <= (others=>'0');
				N_intrn <= '0';
				Z_intrn <= '0';
			else
			    IR_intrn <= IR_ID_in;
			    OPCODE <= IR_ID_in(15 downto 9);
				npc <= NPC_ID_in;
                N_intrn <= N_ID_in;
				Z_intrn <= Z_ID_in;
			end if;
		end if;
		--Latch Output Signals
		if falling_edge(clk) then
		  if(rst = '1') then
		      A_ID_out <= (others=>'0');
		      B_ID_out <= (others=>'0');
		      IR_ID_out <= (others=>'0');
		      pipe_flush_ID_out <= '0';
              branch_ID_out <= '0';
          else
		      A_ID_out <= A_internal;
		      B_ID_out <= B_internal;
		      IR_ID_out <= IR_out_internal;
		      pipe_flush_ID_out <= branch_intrn;
              branch_ID_out <= branch_intrn;
		  end if;
		end if;
	end process;

end Behavioral;
