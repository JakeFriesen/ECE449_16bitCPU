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

entity EX_stage is
    Port ( 
           clk: in STD_LOGIC;
           rst: in STD_LOGIC;
           I_IR: in std_logic_vector(15 downto 0);
           I_A : in STD_LOGIC_VECTOR (15 downto 0);
           I_B : in STD_LOGIC_VECTOR (15 downto 0);
           I_NPC : in STD_LOGIC_VECTOR (5 downto 0);
--           INPUT: in STD_LOGIC_VECTOR(15 downto 0);
                   
           O_result : out STD_LOGIC_VECTOR (15 downto 0);
           O_Vdata : out STD_LOGIC_VECTOR (15 downto 0);
         --  O_V : out STD_LOGIC;
           O_Z_OUTPUT : out std_logic;
           O_N_OUTPUT: out std_logic;
           O_IR: out std_logic_vector(15 downto 0)
           
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
    
-- signal mul_result: STD_LOGIC_VECTOR (31 downto 0);

--signal in_data_sel: std_logic;
signal ALU_A, ALU_B, IR: std_logic_vector( 15 downto 0);
signal ALU_OP: std_logic_vector (2 downto 0);
signal ALU_result, Vdata, ALU_v_result, result: std_logic_vector(15 downto 0);
signal z, n, v, v_en: std_logic;
signal z_output, n_output: std_logic := '0';
signal data_sel: std_logic;    
signal B_data, A_data, imm_data: std_logic_vector(15 downto 0);
signal OPCODE: std_logic_vector(6 downto 0);
signal result_sel,  output_sel: std_logic;
signal NPC : std_logic_vector (5 downto 0);
signal displacement : std_logic_vector (15 downto 0);

--Constants
constant add_op : std_logic_vector(6 downto 0) := "0000001";
constant sub_op : std_logic_vector(6 downto 0) := "0000010";
constant mul_op : std_logic_vector(6 downto 0) := "0000011";
constant nand_op : std_logic_vector(6 downto 0) := "0000100";
constant shl_op : std_logic_vector(6 downto 0) := "0000101";
constant shr_op : std_logic_vector(6 downto 0) := "0000110";
constant test_op : std_logic_vector(6 downto 0) := "0000111";
constant brr_op : std_logic_vector(6 downto 0) := "1000000";
constant brr_n_op : std_logic_vector(6 downto 0) := "1000001";
constant brr_z_op : std_logic_vector(6 downto 0) := "1000010";
constant br_op : std_logic_vector(6 downto 0) := "1000011";
constant br_n_op : std_logic_vector(6 downto 0) := "1000100";
constant br_z_op : std_logic_vector(6 downto 0) := "1000101";
constant br_sub_op : std_logic_vector(6 downto 0) := "1000110";
constant return_op : std_logic_vector(6 downto 0) := "1000111";

begin

   
      ALU_0: ALU port map( ALU_A, ALU_B, ALU_OP, ALU_result, ALU_v_result, Z, N, V);
       
       
       process (clk)
       begin

            if (clk='1' and clk'event) then 
                if(rst ='1') then
                    --ALU_OP <= "000";
                    IR <= (others=>'0');
                    A_data <= (others=>'0');
                    B_data <= (others=>'0');
                    OPCODE <= (others=>'0');
                    NPC <= (others=>'0');
                else
                    IR <= I_IR;
                    --ALU_OP <= I_IR(11 downto 9);
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
            
            if (clk='0' and clk'event) then
                if(rst = '1') then
                    O_result <=(others=>'0');
                    O_Vdata <= (others=>'0');
                --  O_V <= v;
                    O_Z_OUTPUT <= '0';
                    O_N_output <= '0';
                    O_IR <= IR;
                else
                    O_result <= result;
                    O_Vdata <= ALU_V_RESULT;
                --  O_V <= v;
                    O_Z_OUTPUT <= z_output;
                    O_N_output <= n_output;
                    O_IR <= IR;
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
        
        
        result <= ALU_result;
        displacement <= "0000000" & IR(8 downto 0) when IR(8) = '0' else        --Positive
                        "0000000" & (not IR(8 downto 0) + 1) when IR(8) = '1';  --Negative (signed 2's
        
        
        --ALU input B select
        with OPCODE Select
        ALU_B <= imm_data when shl_op | shr_op,                             --Shift
                B_data when add_op | sub_op | mul_op | nand_op | test_op,   --ALU ops
                displacement when brr_op | brr_n_op | brr_z_op,      --BRR ops
                (others=>'0') when others;
        
        --ALU input A select
        with OPCODE select
        ALU_A <= A_data when add_op | sub_op | mul_op | nand_op | shl_op | shr_op | test_op,    --ALU ops
                "0000000000" & NPC when brr_op | brr_n_op | brr_z_op,                           --BRR ops
                (others=>'0') when others;

        --ALU mode select, branch is add or subtract
        ALU_OP <= "001" when (OPCODE = brr_op and IR(8) = '0')  or --Positive, add
                             (OPCODE = brr_n_op and IR(8) = '0') or 
                             (OPCODE = brr_z_op and IR(8) = '0')else
                  "010" when (OPCODE = brr_op and IR(8) = '1')  or  --Neagtive, subtract
                             (OPCODE = brr_n_op and IR(8) = '1') or 
                             (OPCODE = brr_z_op and IR(8) = '1')else
                  IR(11 downto 9);
     
     
end Behavioral;
