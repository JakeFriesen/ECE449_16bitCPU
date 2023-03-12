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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
library work;
use work.Constant_Package.all;

entity EX_stage is
    Port ( 
           clk: in STD_LOGIC;
           rst: in STD_LOGIC;
           I_IR: in std_logic_vector(15 downto 0);
           I_A : in STD_LOGIC_VECTOR (15 downto 0);
           I_B : in STD_LOGIC_VECTOR (15 downto 0);
           I_NPC : in STD_LOGIC_VECTOR (15 downto 0);
           I_branch_clear : in STD_LOGIC;
           O_result : out STD_LOGIC_VECTOR (15 downto 0);
           O_Vdata : out STD_LOGIC_VECTOR (15 downto 0);
           O_A : out STD_LOGIC_VECTOR (15 downto 0);
           O_B : out STD_LOGIC_VECTOR (15 downto 0);
           O_Z_OUTPUT : out std_logic;
           O_N_OUTPUT: out std_logic;
           O_IR: out std_logic_vector(15 downto 0);
           O_NPC : out std_logic_vector (15 downto 0)
           );
         
end EX_stage;

architecture Behavioral of EX_stage is

--ALU
component ALU is
    port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           sel : in STD_LOGIC_VECTOR (2 downto 0);
           result : out STD_LOGIC_VECTOR (15 downto 0);
           v_result : out STD_LOGIC_VECTOR (15 downto 0);
           Z : out STD_LOGIC;
           N : out STD_LOGIC;
           V : out STD_LOGIC
           );
end component;

--signal in_data_sel: std_logic;
signal ALU_A, ALU_B, IR: std_logic_vector( 15 downto 0) := (others=>'0');
signal ALU_OP: std_logic_vector (2 downto 0) := (others=>'0');
signal ALU_result, Vdata, ALU_v_result, result: std_logic_vector(15 downto 0) := (others=>'0');
signal z, n, v, v_en: std_logic := '0';
signal z_output, n_output: std_logic := '0'; 
signal A_data: std_logic_vector(15 downto 0);
signal NPC : std_logic_vector (15 downto 0);
signal disp_l, disp_s : std_logic_vector (15 downto 0);
signal data_sel: std_logic := '0';    
signal B_data, imm_data: std_logic_vector(15 downto 0) := (others=>'0');
signal OPCODE: std_logic_vector(6 downto 0) := (others=>'0');
signal result_sel,  output_sel: std_logic := '0';

begin

   --ALU Instance
    ALU_0: ALU port map( 
        A=>ALU_A, 
        B=>ALU_B, 
        sel=>ALU_OP, 
        result=>ALU_result, 
        v_result=>ALU_v_result, 
        Z=>Z, 
        N=>N, 
        V=>V
    );
   
    process (clk)
    begin
        --Positive Latch
        if (clk='1' and clk'event) then 
            if(rst ='1' or I_branch_clear = '1') then
                IR <= (others=>'0');
                A_data <= (others=>'0');
                B_data <= (others=>'0');
                OPCODE <= (others=>'0');
                NPC <= (others=>'0');
            else
                IR <= I_IR;
                A_data <= I_A;          
                B_data <= I_B;
                OPCODE<= I_IR(15 downto 9);
                NPC <= I_NPC;
                --Sign extend immediate
                if(I_IR(5) = '1') then
                    imm_data <= "1111111111" & I_IR(5 downto 0);
                else
                    imm_data <= "0000000000" & I_IR(5 downto 0);
                end if; 
            end if;
        end if;
        --Negative Latch
        if (clk='0' and clk'event) then
            if(rst = '1') then
                O_result <=(others=>'0');
                O_Vdata <= (others=>'0');
            --  O_V <= v;
                O_Z_OUTPUT <= '0';
                O_N_output <= '0';
                O_IR <= IR;
                O_NPC <= (others=>'0');
            else
                O_result <= result;
                O_Vdata <= ALU_V_RESULT;
                O_A <= I_A;
                O_B <= I_B;
                O_Z_OUTPUT <= z_output;
                O_N_output <= n_output;
                O_IR <= IR;
                O_NPC <= NPC;
            end if;
        end if;
    end process;
    
    
             
    process(ALU_OP, ALU_result)
    begin
        if(ALU_OP = "111") then       
            Z_OUTPUT <= z;
            N_OUTPUT <= n;
        else
            Z_OUTPUT <= Z_OUTPUT;
            N_OUTPUT <= N_OUTPUT;
        end if;
    end process;
    
    
    --Push the next program counter + 1 into the ALU result when branching to subroutine
    --Put R7 into the ALU result when returning from subroutine
    with OPCODE select
    result <= A_data when return_op,
              ALU_result when others;
    
    --Switch Case for each opcode
    --Defines ALU_A, ALU_B, ALU_OP
    process(OPCODE) begin
        case OPCODE is 
            when add_op | sub_op | mul_op | nand_op | test_op =>
            --Regular Arithmetic Operations
                ALU_B <= B_data;
                ALU_A <= A_data;
                ALU_OP <= IR(11 downto 9);
            when shl_op | shr_op =>
            --Shift Operations
                ALU_B <= imm_data;
                ALU_A <= A_data;
                ALU_OP <= IR(11 downto 9);
            when brr_op | brr_n_op | brr_z_op =>
            --PC Relative Branches
                ALU_A <= NPC;
                --Set op to add or subtract
                ALU_OP <= "001";
                --Sign Extend the Immediate value
                if(IR(8) = '0') then
                    ALU_B <= "0000000" & IR(8 downto 0);
                else
                    ALU_B <= "1111111" & IR(8 downto 0);
                end if;
            when br_op | br_n_op | br_z_op | br_sub_op =>
            --Register Relative Branches
                ALU_A <= A_data;
                ALU_OP <= "001";
                --Sign Extend the Immediate value
                if(IR(5) = '0') then
                    ALU_B <= "0000000000" & IR(5 downto 0);
                else
                    ALU_B <= "1111111111" & IR(5 downto 0);
                end if;
            when others =>
            --Any other operations
                ALU_B <= (others=>'0');
                ALU_A <= (others=>'0');
                ALU_OP <= (others=>'0');
        end case;
    end process;
     
end Behavioral;
