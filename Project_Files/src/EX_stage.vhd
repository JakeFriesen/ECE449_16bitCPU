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


entity EX_stage is
    Port ( 
           clk: in STD_LOGIC;
           rst: in STD_LOGIC;
           halt: in STD_LOGIC;
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
           NPC_EX_out : out std_logic_vector (15 downto 0);
           br_clear_in: in std_logic
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
signal B_data, imm_data, sign_ext : std_logic_vector(15 downto 0) := (others=>'0');
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
            if(rst ='1' or br_clear_in = '1') then
                IR <= (others=>'0');
                A_data <= (others=>'0');
                B_data <= (others=>'0');
                OPCODE <= (others=>'0');
                NPC <= (others=>'0');
            elsif (halt = '1') then 
                -- Do not update anything
            else
                IR <= IR_EX_in;
                A_data <= A_EX_in;          
                B_data <= B_EX_in;
                OPCODE<= IR_EX_in(15 downto 9);
                NPC <= NPC_EX_in;
            end if;
        end if;
        --Negative Latch
        if (clk='0' and clk'event) then
            if(rst = '1' or halt='1') then
                Result_EX_out <=(others=>'0');
                vdata_EX_out <= (others=>'0');
                Z_EX_out <= '0';
                N_EX_out <= '0';
                IR_EX_out <= (others=>'0');
                NPC_EX_out <= (others=>'0');
            else
                Result_EX_out <= result;
                vdata_EX_out <= ALU_V_RESULT;
                A_EX_out <= A_data;
                B_EX_out <= B_data;
                Z_EX_out <= z_output;
                N_EX_out <= n_output;
                IR_EX_out <= IR;
                NPC_EX_out <= NPC;
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
    sign_ext <= (others=>IR(8)) when (OPCODE =brr_op) or (OPCODE =brr_n_op) or (OPCODE =brr_z_op) 
                else (others=>IR(5));
    
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
                -- shifted left by 1 for x2
                if(IR(8) = '0') then
                    ALU_B <= "000000" & IR(8 downto 0) & '0';
--                    ALU_B <= "0000000" & IR(8 downto 0);
                else
                    ALU_B <= "111111" & IR(8 downto 0) & '0';
--                    ALU_B <= "1111111" & IR(8 downto 0);
                end if;
            when br_op | br_n_op | br_z_op | br_sub_op =>
            --Register Relative Branches
                ALU_A <= A_data;
                ALU_OP <= "001";
                --Sign Extend the Immediate value
                if(IR(5) = '0') then
                    ALU_B <= "000000000" & IR(5 downto 0)  & '0';
--                    ALU_B <= "0000000000" & IR(5 downto 0);
                else
                    ALU_B <= "111111111" & IR(5 downto 0) & '0';
--                    ALU_B <= "1111111111" & IR(5 downto 0);
                end if;
            when others =>
            --Any other operations
                ALU_B <= (others=>'0');
                ALU_A <= (others=>'0');
                ALU_OP <= (others=>'0');
        end case;
    end process;
     
end Behavioral;
