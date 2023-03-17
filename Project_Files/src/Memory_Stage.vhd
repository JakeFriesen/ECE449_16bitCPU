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
use ieee.std_logic_unsigned.all;


entity Memory_Stage is
    Port ( Result_MEM_in : in STD_LOGIC_VECTOR (15 downto 0);
           IR_MEM_in : in STD_LOGIC_VECTOR (15 downto 0);
           N_MEM_in : in STD_LOGIC;
           Z_MEM_in : in STD_LOGIC;
           clk, rst : in STD_LOGIC;
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
           IR_MEM_out : out STD_LOGIC_VECTOR (15 downto 0);
           NPC_MEM_in : in STD_LOGIC_VECTOR (15 downto 0);
           vdata_MEM_in, A_MEM_in, B_MEM_in : in STD_LOGIC_VECTOR (15 downto 0);
           vdata_MEM_out : out STD_LOGIC_VECTOR (15 downto 0));
end Memory_Stage;

architecture Behavioral of Memory_Stage is
    signal IR, ALU, Overflow, ram_output, NPC : std_logic_vector (15 downto 0);
    signal flags : std_logic_vector (1 downto 0);
    signal branch_internal : std_logic;

begin
    --Latch Process
    process(clk)
    begin
        if(rst = '1') then
        --Reset
            IR_MEM_out <= (others=>'0');
            vdata_MEM_out <= (others=>'0');
            Result_MEM_out <= (others=>'0');
            memdata_MEM_out <= (others=>'0');  
        end if;    
        if(clk'event and clk = '1') then
        --Latch Incoming signals
            if(branch_internal = '1') then
            --Internal Branch set, clear the incoming buffer
                flags <= "00";
                IR <= (others=>'0');
                ALU <= (others=>'0');
                Overflow <= (others=>'0');
                NPC <= (others=>'0');
            else
                flags <= N_MEM_in & Z_MEM_in;
                IR <= IR_MEM_in;
                ALU <= Result_MEM_in;
                Overflow <= vdata_MEM_in;
                NPC <= NPC_MEM_in;
            end if;
        end if;
        if(clk'event and clk = '0') then
        --Latch Outgoing signals
            vdata_MEM_out <= Overflow;
            IR_MEM_out <= IR;
            if( IR(15 downto 9) = br_sub_op) then
                Result_MEM_out <= NPC + 1;
            else
                Result_MEM_out <= ALU;
            end if;
            
            if(IR(15 downto 9) = mov_op or IR(15 downto 9) = out_op) then
                memdata_MEM_out <= A_MEM_in;
            else
                memdata_MEM_out <= ram_data_A;
            end if;  
                
        end if;
    end process;

    --Branch Choice - Combinational, not latched output
    --This is very redundant, and could always output an address, but this will help to debug branching issues
    branch_internal <=
        '1' when IR(15 downto 9) = brr_op else                          --BRR (64)
        '1' when (IR(15 downto 9) = brr_n_op and flags(1) = '1') else   --BRR.N (65)
        '1' when (IR(15 downto 9) = brr_z_op and flags (0) = '1') else  --BRR.Z (66)
        '1' when (IR(15 downto 9) = br_op) else                         --BR (67)
        '1' when (IR(15 downto 9) = br_n_op and flags (1) = '1') else   --BR.N (68)
        '1' when (IR(15 downto 9) = br_z_op and flags (0) = '1') else   --BR.Z (69)
        '1' when (IR(15 downto 9) = br_sub_op) else                     --BR.SUB (70)
        '1' when (IR(15 downto 9) = return_op) else                     --RETURN (71)
        '0';                                                            --Don't branch any other time
    --Branch Address Choice - Combinational, not banched output.
    --This is very redundant, and could always output an address, but this will help to debug branching issues
    branch_addr <=
        ALU when (IR(15 downto 9) = brr_op) else                     --BRR (64)
        ALU when (IR(15 downto 9) = "1000001" and flags(1) = '1') else  --BRR.N (65)
        ALU when (IR(15 downto 9) = "1000010" and flags (0) = '1') else --BRR.Z (66)
        ALU when (IR(15 downto 9) = "1000011") else                     --BR (67)
        ALU when (IR(15 downto 9) = "1000100" and flags (1) = '1') else --BR.N (68)
        ALU when (IR(15 downto 9) = "1000101" and flags (0) = '1') else --BR.Z (69)
        ALU when (IR(15 downto 9) = "1000110") else                     --BR.SUB (70)
        ALU when (IR(15 downto 9) = "1000111") else                     --RETURN (71)
        (others => '0');                                                --Keep at 0 any other time
    
    pipe_flush <= branch_internal;
    branch <= branch_internal;

    --RAM Access
    with IR_MEM_in(15 downto 9) Select
        ram_wren_A <=   '1' when store_op | push_op, --STR (17), PUSH (96)
                    '0' when others;  
                    
    with IR_MEM_in(15 downto 9) Select
         ram_en_A <=  '1' when store_op | load_op | push_op | pop_op,
                     '0' when others;  
    
    ram_addr_A <= A_MEM_in(15 downto 0);
    ram_wrdata_A <=  B_MEM_in;
    
        


end Behavioral;
